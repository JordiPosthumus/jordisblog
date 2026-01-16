library(data.table)
library(jsonlite)
library(httr)

fetch_kraken_ohlc <- function(pair = "XBTUSD", interval = 1440, since = NULL) {
  base_url <- "https://api.kraken.com/0/public/OHLC"
  
  params <- list(
    pair = pair,
    interval = interval
  )
  
  if (!is.null(since)) {
    params$since <- since
  }
  
  response <- GET(base_url, query = params)
  
  if (status_code(response) != 200) {
    stop(paste("Failed to fetch data from Kraken API. Status:", status_code(response)))
  }
  
  content <- content(response, "text", encoding = "UTF-8")
  json_data <- fromJSON(content)
  
  if (length(json_data$error) > 0 && nchar(json_data$error[[1]]) > 0) {
    stop(paste("Kraken API error:", paste(json_data$error, collapse = ", ")))
  }
  
  pair_name <- names(json_data$result)[1]
  ohlc_data <- json_data$result[[pair_name]]
  
  dt <- as.data.table(ohlc_data)
  setnames(dt, c("Date", "Open", "High", "Low", "Close", "VWAP", "Volume", "Trades"))
  
  dt[, Date := as.POSIXct(as.numeric(Date), origin = "1970-01-01", tz = "UTC")]
  
  cols_numeric <- c("Open", "High", "Low", "Close", "VWAP", "Volume", "Trades")
  for (col in cols_numeric) {
    dt[, (col) := as.numeric(get(col))]
  }
  
  return(dt)
}

calculate_rolling_volatility <- function(dt_daily) {
  dt_daily[, Return := (Close / shift(Close) - 1)]
  
  dt_daily[, RollingVol_7d := sapply(1:.N, function(i) {
    if (i < 7) return(NA)
    sd(dt_daily$Return[(i-6):i], na.rm = TRUE) * sqrt(252) * 100
  })]
  
  dt_daily[, RollingVol_30d := sapply(1:.N, function(i) {
    if (i < 30) return(NA)
    sd(dt_daily$Return[(i-29):i], na.rm = TRUE) * sqrt(252) * 100
  })]
  
  latest_date <- max(dt_daily$Date, na.rm = TRUE)
  
  chart_data <- dt_daily[Date >= latest_date - (3 * 365)]
  chart_data_chart <- chart_data[, .(
    date = format(Date, "%Y-%m-%d"),
    price = round(Close, 2),
    rolling_vol_7d = round(RollingVol_7d, 2),
    rolling_vol_30d = round(RollingVol_30d, 2)
  )]
  
  chart_data_chart <- na.omit(chart_data_chart)
  
  return(chart_data_chart)
}

# Fetch Bitcoin data
if (file.exists('btc-ohlc-data.RDS')) {
  cat("Using local Bitcoin data...\n")
  dt_btc <- readRDS('btc-ohlc-data.RDS')
  
  # Convert to daily data
  dt_btc[, DailyDate := as.Date(Date)]
  btc_daily <- dt_btc[!duplicated(DailyDate), .(Close = last(Close)), by = DailyDate]
  setnames(btc_daily, 'DailyDate', 'Date')
} else {
  cat("Local Bitcoin data not found, fetching from Kraken API...\n")
  
  three_years_ago <- as.numeric(as.POSIXct(Sys.time()) - (3 * 365 * 24 * 3600))
  
  dt_btc <- fetch_kraken_ohlc(pair = "XBTUSD", interval = 1440, since = three_years_ago)
  
  if (nrow(dt_btc) < 100) {
    stop("Not enough Bitcoin data fetched")
  }
  
  # Convert to daily data
  dt_btc[, DailyDate := as.Date(Date)]
  btc_daily <- dt_btc[!duplicated(DailyDate), .(Close = last(Close)), by = DailyDate]
  setnames(btc_daily, 'DailyDate', 'Date')
  
  cat(paste("Fetched", nrow(dt_btc), "Bitcoin data points\n"))
}

cat(paste("Processing", nrow(btc_daily), "days of Bitcoin data...\n"))

# Calculate volatility for Bitcoin
btc_chart_data <- calculate_rolling_volatility(btc_daily)

cat(paste("Generated", nrow(btc_chart_data), "Bitcoin chart data points (3 years)\n"))

# Load Apple data from Python script
aapl_data_file <- '/Users/jordiposthumus/Documents/Projects/SilverBug/jordisblog/public/aapl-data.json'

if (file.exists(aapl_data_file)) {
  cat("Loading Apple data from JSON file...\n")
  
  aapl_json <- readLines(aapl_data_file, warn = FALSE)
  aapl_raw <- fromJSON(paste(aapl_json, collapse = ""))
  
  aapl_dt <- as.data.table(aapl_raw)
  aapl_dt[, Date := as.Date(date)]
  setnames(aapl_dt, "price", "Close")
  
  cat(paste("Loaded", nrow(aapl_dt), "days of Apple data\n"))
  
  # Calculate volatility for Apple
  aapl_chart_data <- calculate_rolling_volatility(aapl_dt)
  
  cat(paste("Generated", nrow(aapl_chart_data), "Apple chart data points (3 years)\n"))
} else {
  cat("Warning: Apple data file not found. Skipping Apple charts.\n")
  aapl_chart_data <- NULL
}

# Load MSTR data from Python script
mstr_data_file <- '/Users/jordiposthumus/Documents/Projects/SilverBug/jordisblog/public/mstr-data.json'

if (file.exists(mstr_data_file)) {
  cat("Loading MicroStrategy data from JSON file...\n")
  
  mstr_json <- readLines(mstr_data_file, warn = FALSE)
  mstr_raw <- fromJSON(paste(mstr_json, collapse = ""))
  
  mstr_dt <- as.data.table(mstr_raw)
  mstr_dt[, Date := as.Date(date)]
  setnames(mstr_dt, "price", "Close")
  
  cat(paste("Loaded", nrow(mstr_dt), "days of MicroStrategy data\n"))
  
  # Calculate volatility for MSTR
  mstr_chart_data <- calculate_rolling_volatility(mstr_dt)
  
  cat(paste("Generated", nrow(mstr_chart_data), "MSTR chart data points (3 years)\n"))
} else {
  cat("Warning: MSTR data file not found. Skipping MSTR charts.\n")
  mstr_chart_data <- NULL
}

# Load Silver data from Python script
silver_data_file <- '/Users/jordiposthumus/Documents/Projects/SilverBug/jordisblog/public/silver-data.json'

if (file.exists(silver_data_file)) {
  cat("Loading Silver spot price data from JSON file...\n")
  
  silver_json <- readLines(silver_data_file, warn = FALSE)
  silver_raw <- fromJSON(paste(silver_json, collapse = ""))
  
  silver_dt <- as.data.table(silver_raw)
  silver_dt[, Date := as.Date(date)]
  setnames(silver_dt, "price", "Close")
  
  cat(paste("Loaded", nrow(silver_dt), "days of Silver data\n"))
  
  # Calculate volatility for Silver
  silver_chart_data <- calculate_rolling_volatility(silver_dt)
  
  cat(paste("Generated", nrow(silver_chart_data), "Silver chart data points (3 years)\n"))
} else {
  cat("Warning: Silver data file not found. Skipping Silver charts.\n")
  silver_chart_data <- NULL
}

# Create output object
output <- list(
  last_updated = format(Sys.time(), "%Y-%m-%d %H:%M:%S UTC"),
  bitcoin = list(
    symbol = "Bitcoin",
    dates = btc_chart_data$date,
    prices = btc_chart_data$price,
    rolling_vol_7d = btc_chart_data$rolling_vol_7d,
    rolling_vol_30d = btc_chart_data$rolling_vol_30d
  )
)

# Add Apple data if available
if (!is.null(aapl_chart_data) && nrow(aapl_chart_data) > 0) {
  output$apple <- list(
    symbol = "Apple",
    dates = aapl_chart_data$date,
    prices = aapl_chart_data$price,
    rolling_vol_7d = aapl_chart_data$rolling_vol_7d,
    rolling_vol_30d = aapl_chart_data$rolling_vol_30d
  )
}

# Add MSTR data if available
if (!is.null(mstr_chart_data) && nrow(mstr_chart_data) > 0) {
  output$mstr <- list(
    symbol = "MicroStrategy (MSTR)",
    dates = mstr_chart_data$date,
    prices = mstr_chart_data$price,
    rolling_vol_7d = mstr_chart_data$rolling_vol_7d,
    rolling_vol_30d = mstr_chart_data$rolling_vol_30d
  )
}

# Add Silver data if available
if (!is.null(silver_chart_data) && nrow(silver_chart_data) > 0) {
  output$silver <- list(
    symbol = "Silver (SLV)",
    dates = silver_chart_data$date,
    prices = silver_chart_data$price,
    rolling_vol_7d = silver_chart_data$rolling_vol_7d,
    rolling_vol_30d = silver_chart_data$rolling_vol_30d
  )
}

# Write JSON to blog directory
output_path <- '/Users/jordiposthumus/Documents/Projects/SilverBug/jordisblog/public/bitcoin-volatility.json'
write(toJSON(output, pretty = TRUE, auto_unbox = TRUE), output_path)

cat("Bitcoin volatility data updated successfully!\n")
cat(paste("Output written to:", output_path, "\n"))