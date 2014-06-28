Parse.Cloud.afterSave("Business", function(request) {
  query = new Parse.Query("UpdateTimestamps");
  query.get("Y16hvazxpA", {
    success: function(timestamp) {
		timestamp.set("TimeStamp",request.object.updatedAt);
    	timestamp.save();
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });
});

Parse.Cloud.afterSave("Info", function(request) {
  query = new Parse.Query("UpdateTimestamps");
  query.get("D6Gl39I29i", {
    success: function(timestamp) {
		timestamp.set("TimeStamp",request.object.updatedAt);
    	timestamp.save();
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });
});

Parse.Cloud.afterSave("Links", function(request) {
  query = new Parse.Query("UpdateTimestamps");
  query.get("u28ju6wQ9r", {
    success: function(timestamp) {
		timestamp.set("TimeStamp",request.object.updatedAt);
    	timestamp.save();
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });
});

Parse.Cloud.afterSave("Locations", function(request) {
  query = new Parse.Query("UpdateTimestamps");
  query.get("aYBFq7xwkd", {
    success: function(timestamp) {
		timestamp.set("TimeStamp",request.object.updatedAt);
    	timestamp.save();
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });
});

Parse.Cloud.afterSave("TagSet", function(request) {
  query = new Parse.Query("UpdateTimestamps");
  query.get("dq9No4Qb9Y", {
    success: function(timestamp) {
		timestamp.set("TimeStamp",request.object.updatedAt);
    	timestamp.save();
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });
});

Parse.Cloud.afterSave("Tag", function(request) {
  query = new Parse.Query("UpdateTimestamps");
  query.get("dRSYvir7j2", {
    success: function(timestamp) {
		timestamp.set("TimeStamp",request.object.updatedAt);
    	timestamp.save();
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });
});

Parse.Cloud.afterSave("TagConnection", function(request) {
  query = new Parse.Query("UpdateTimestamps");
  query.get("tnCmlRew6f", {
    success: function(timestamp) {
		timestamp.set("TimeStamp",request.object.updatedAt);
    	timestamp.save();
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });
});

Parse.Cloud.afterSave("Settings", function(request) {
  query = new Parse.Query("UpdateTimestamps");
  query.get("F4w80xGg39", {
    success: function(timestamp) {
		timestamp.set("TimeStamp",request.object.updatedAt);
    	timestamp.save();
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });
});

Parse.Cloud.beforeDelete("Business", function(request, response) {
  	var DeleteHistory = Parse.Object.extend("DeleteHistory");
  	var newDeleteEntry = new DeleteHistory();
  	newDeleteEntry.set("delObjectID",request.object.id);
  	newDeleteEntry.set("table","Business");
	newDeleteEntry.save(null).then(function(message) {
    	response.success();
  }, function(error) {
      	response.error("Error " + error.code + " : " + error.message);
  });
});


Parse.Cloud.beforeDelete("Info", function(request, response) {
  	var DeleteHistory = Parse.Object.extend("DeleteHistory");
  	var newDeleteEntry = new DeleteHistory();
  	newDeleteEntry.set("delObjectID",request.object.id);
  	newDeleteEntry.set("table","Info");
	newDeleteEntry.save(null).then(function(message) {
    	response.success();
  }, function(error) {
      	response.error("Error " + error.code + " : " + error.message);
  });
});

Parse.Cloud.beforeDelete("Links", function(request, response) {
  	var DeleteHistory = Parse.Object.extend("DeleteHistory");
  	var newDeleteEntry = new DeleteHistory();
  	newDeleteEntry.set("delObjectID",request.object.id);
  	newDeleteEntry.set("table","Links");
	newDeleteEntry.save(null).then(function(message) {
    	response.success();
  }, function(error) {
      	response.error("Error " + error.code + " : " + error.message);
  });
});

Parse.Cloud.beforeDelete("Locations", function(request, response) {
  	var DeleteHistory = Parse.Object.extend("DeleteHistory");
  	var newDeleteEntry = new DeleteHistory();
  	newDeleteEntry.set("delObjectID",request.object.id);
  	newDeleteEntry.set("table","Locations");
	newDeleteEntry.save(null).then(function(message) {
    	response.success();
  }, function(error) {
      	response.error("Error " + error.code + " : " + error.message);
  });
});

Parse.Cloud.beforeDelete("Tag", function(request, response) {
  	var DeleteHistory = Parse.Object.extend("DeleteHistory");
  	var newDeleteEntry = new DeleteHistory();
  	newDeleteEntry.set("delObjectID",request.object.id);
  	newDeleteEntry.set("table","Tag");
	newDeleteEntry.save(null).then(function(message) {
    	response.success();
  }, function(error) {
      	response.error("Error " + error.code + " : " + error.message);
  });
});

Parse.Cloud.beforeDelete("TagConnection", function(request, response) {
  	var DeleteHistory = Parse.Object.extend("DeleteHistory");
  	var newDeleteEntry = new DeleteHistory();
  	newDeleteEntry.set("delObjectID",request.object.id);
  	newDeleteEntry.set("table","TagConnection");
	newDeleteEntry.save(null).then(function(message) {
    	response.success();
  }, function(error) {
      	response.error("Error " + error.code + " : " + error.message);
  });
});

Parse.Cloud.beforeDelete("TagSet", function(request, response) {
  	var DeleteHistory = Parse.Object.extend("DeleteHistory");
  	var newDeleteEntry = new DeleteHistory();
  	newDeleteEntry.set("delObjectID",request.object.id);
  	newDeleteEntry.set("table","TagSet");
	newDeleteEntry.save(null).then(function(message) {
    	response.success();
  }, function(error) {
      	response.error("Error " + error.code + " : " + error.message);
  });
});

Parse.Cloud.job("getForecast", function(request, status) {

var apiKey='d9b6767efb140cd602f07adf5a9018af';
var latitude='49.2759258';
var longitude='-123.1150547';

Parse.Cloud.httpRequest({
   url: 'https://api.forecast.io/forecast/'+apiKey+'/'+latitude+','+longitude+'?units=ca',
  success: function(httpResponse) {
  	var result = JSON.parse(httpResponse.text);
  	var WeatherData = Parse.Object.extend("WeatherData");
  	var newWeather = new WeatherData();
  	/*console.log(result.currently.temperature);*/
  	newWeather.set("currentTemp",result.currently.temperature);
  	newWeather.set("apparentTemp",result.currently.apparentTemperature);
  	newWeather.set("summary",result.currently.icon);
  	newWeather.save(null).then(function(message) {
    status.success('Success');
  }, function(error) {
   status.error(error)
  });
  },
  error: function(httpResponse) {
  status,error(httpResponse);
    console.error('Request failed with response code ' + httpResponse.status);
  }
});



});