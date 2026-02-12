'use strict';

var express = require('express'),
    app = express();


var bodyParser = require('body-parser');
var port = 8020;

app.use(bodyParser.json());

// app.get('/', function(request,response){
//     response.send('Hello World');
// })


app.listen(port, function(){
    console.log('Server Running at port ' + port);
})