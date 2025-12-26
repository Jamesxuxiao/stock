# Stock Analysis Jupyter Environment

A Docker-based Jupyter environment for stock market analysis and visualization.

## Features

- **Jupyter Lab**: Interactive development environment
- **Financial Libraries**: yfinance, yahoo_fin for stock data
- **Visualization**: Plotly, cufflinks for interactive charts
- **Database Support**: Multiple database connectors (SQL Server, Oracle, Snowflake, etc.)
- **Mathematical Tools**: SageMath, SciPy for advanced analysis

## Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Git (for cloning)

### Setup

1. Clone or navigate to the repository:
```bash
cd c:\Documents\Genai\stock
```

2. Build and start the container:
```bash
docker-compose up --build
```

3. Access Jupyter Lab:
- Open your browser and go to: `http://localhost:10000`
- The token will be displayed in the terminal output

### Usage

1. **Stock Analysis**: Open `stock_analysis.ipynb` for a comprehensive stock analysis template
2. **Create New Notebooks**: Use the Jupyter Lab interface to create new analysis notebooks
3. **Data Storage**: Your notebooks are saved to the mounted volume

## Key Libraries

- **yfinance**: Download market data from Yahoo! Finance
- **yahoo_fin**: Additional Yahoo Finance data
- **plotly**: Interactive plotting
- **pandas**: Data manipulation
- **numpy**: Numerical computing
- **SQLAlchemy**: Database ORM

## Database Connections

The environment includes drivers for:
- Microsoft SQL Server (pymssql)
- Oracle (cx_Oracle, oracledb)
- Snowflake (snowflake-connector-python)
- Teradata (teradatasql)

## Configuration

### Volume Mapping
The docker-compose.yml maps your local notebooks directory:
```yaml
volumes:
  - C:/Documents/eLearning/Notebook:/home/jovyan/work
```

Update this path to match your preferred local directory.

### Port Configuration
- Jupyter Lab runs on port `10000` (mapped to container port `8888`)

## Troubleshooting

### Container Won't Start
1. Check Docker is running
2. Verify volume paths exist
3. Check for port conflicts

### Permission Issues
The container is configured with user permissions (UID: 1000, GID: 100). If you encounter permission issues, you may need to adjust these values.

### Package Installation
Additional packages can be installed in the notebook using:
```python
!pip install package_name
```

## Examples

### Basic Stock Data
```python
import yfinance as yf

# Get Apple stock data
aapl = yf.Ticker('AAPL')
data = aapl.history(period='1y')
print(data.tail())
```

### Interactive Plotting
```python
import plotly.graph_objects as go

fig = go.Figure(data=go.Candlestick(x=data.index,
                                    open=data['Open'],
                                    high=data['High'],
                                    low=data['Low'],
                                    close=data['Close']))
fig.show()
```

## Support

For issues or questions:
1. Check the Docker logs: `docker-compose logs`
2. Verify all prerequisites are installed
3. Check network and firewall settings for port access
