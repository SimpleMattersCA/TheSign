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

Parse.Cloud.afterSave("BusinessCategory", function(request) {
  query = new Parse.Query("UpdateTimestamps");
  query.get("BZOidMhX7h", {
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

Parse.Cloud.afterSave("Area", function(request) {
  query = new Parse.Query("UpdateTimestamps");
  query.get("UuEC4qvQn2", {
    success: function(timestamp) {
		timestamp.set("TimeStamp",request.object.updatedAt);
    	timestamp.save();
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });
});

Parse.Cloud.afterSave("Context", function(request) {
  query = new Parse.Query("UpdateTimestamps");
  query.get("QPVTlUILC9", {
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

Parse.Cloud.afterSave("Templates", function(request) {
  query = new Parse.Query("UpdateTimestamps");
  query.get("mc77vjW8HQ", {
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

Parse.Cloud.beforeDelete("BusinessCategory", function(request, response) {
  	var DeleteHistory = Parse.Object.extend("DeleteHistory");
  	var newDeleteEntry = new DeleteHistory();
  	newDeleteEntry.set("delObjectID",request.object.id);
  	newDeleteEntry.set("table","BusinessCategory");
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

Parse.Cloud.beforeDelete("Area", function(request, response) {
  	var DeleteHistory = Parse.Object.extend("DeleteHistory");
  	var newDeleteEntry = new DeleteHistory();
  	newDeleteEntry.set("delObjectID",request.object.id);
  	newDeleteEntry.set("table","Area");
	newDeleteEntry.save(null).then(function(message) {
    	response.success();
  }, function(error) {
      	response.error("Error " + error.code + " : " + error.message);
  });
});

Parse.Cloud.beforeDelete("Context", function(request, response) {
  	var DeleteHistory = Parse.Object.extend("DeleteHistory");
  	var newDeleteEntry = new DeleteHistory();
  	newDeleteEntry.set("delObjectID",request.object.id);
  	newDeleteEntry.set("table","Context");
	newDeleteEntry.save(null).then(function(message) {
    	response.success();
  }, function(error) {
      	response.error("Error " + error.code + " : " + error.message);
  });
});

Parse.Cloud.beforeDelete("Templates", function(request, response) {
  	var DeleteHistory = Parse.Object.extend("DeleteHistory");
  	var newDeleteEntry = new DeleteHistory();
  	newDeleteEntry.set("delObjectID",request.object.id);
  	newDeleteEntry.set("table","Templates");
	newDeleteEntry.save(null).then(function(message) {
    	response.success();
  }, function(error) {
      	response.error("Error " + error.code + " : " + error.message);
  });
});




Parse.Cloud.job("getForecast", function(request, status) {
var _ = require('underscore.js');

var apiKey='d9b6767efb140cd602f07adf5a9018af';

var Area = Parse.Object.extend("Area");
var query = new Parse.Query(Area);
query.find().then(function(areas) 
  {
  console.log(areas.length);
    var promises = [];
    
    _.each(areas, function(area) 
    {
     	promises.push(Parse.Cloud.httpRequest({
      	url: 'https://api.forecast.io/forecast/'+apiKey+'/'+area.get('latitude')+','+area.get('longitude')+'?units=ca'
      	}).then(function(httpResponse)
      		{
				var result = JSON.parse(httpResponse.text);
				area.set("currentTemperature",result.currently.apparentTemperature);
				area.set("currentWeather",result.currently.icon);
				console.log(result.currently.temperature);
				return area.save();
			},function(error)
			{
			  	status.error("Error in getting forecast");
			})
		);
	});
	
	return Parse.Promise.when(promises);
   //status.success('Success');
  }).then(function(){
  	status.success("Done");
	});
});