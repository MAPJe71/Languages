var FC = require('modbus-stack').FUNCTION_CODES;

var client = require('modbus-stack/client').createClient(502);

client.request(FC.READ_INPUT_REGISTERS, 0, 5, function(err, response) {
  if (err) throw err;
  console.log(response);
  client.end();
});
