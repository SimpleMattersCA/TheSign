
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
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