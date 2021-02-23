{

  "data": {
    "url": "https://raw.githubusercontent.com/RDeconomist/rapidcharts/master/waveHeights_today.csv"
  },

   "title": {
    "text": "Croyde Bay",
    "subtitle":"Today's 1-week swell forecast, from MSW",
    "subtitleFontStyle":"italic",
    "subtitleFontSize":10,
    "anchor": "start",
    "color": "black"
  },
  
  "height":300,
  "width":350,

  "mark": {
    "type":"area",
    "color":"#0BB5FF"
      },
    
  "encoding": {
      
      "x": {
        "field": "days",
        "type": "quantitative",
        "title": "Forecast (days ahead)"        
      },
      
      "y": {
        "field": "croyde_high",
        "type": "quantitative",
        "title": "Predicted wave height",
        "grid":null
      },

      "y2": {
        "field": "croyde_low",
        "type": "quantitative",
        "title": "Predicted wave height",
        "grid":null
      }
    }
  }