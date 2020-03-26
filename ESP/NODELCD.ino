#include<LiquidCrystal.h>
#include<DHT.h>
#include <WiFiClient.h> 
#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>
 
// initialize the library by associating any needed LCD interface pin
// with the arduino pin number it is connected to
const int RS = D2, EN = D3, d4 = D5, d5 = D6, d6 = D7, d7 = D8;
LiquidCrystal lcd(RS, EN, d4, d5, d6, d7);
#define DHpin D4
#define pwm D1
#define DHTTYPE DHT11
byte dat [5];
DHT dht(DHpin, DHTTYPE);
byte degree[8] = 
              {
                0b00011,
                0b00011,
                0b00000,
                0b00000,
                0b00000,
                0b00000,
                0b00000,
                0b00000
              };

/* Set these to your desired credentials. */
const char *ssid = "Brando!";  //ENTER YOUR WIFI SETTINGS
const char *password = "R31145R3N123!";
const char *host = "192.168.0.123:8080";  
void setup()
{
  dht.begin();
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  Serial.begin(9600);
  delay(1000);
  Serial.begin(115200);
  WiFi.mode(WIFI_OFF);        //Prevents reconnection issue (taking too long to connect)
  delay(1000);
  WiFi.mode(WIFI_STA);        //This line hides the viewing of ESP as wifi hotspot
  
  WiFi.begin(ssid, password);     //Connect to your WiFi router
  Serial.println("");
 
  Serial.print("Connecting");
  // Wait for connection
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
 
  //If connection successful show IP address in serial monitor
  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());  //IP address assigned to your ESP
  lcd.createChar(1, degree);
  lcd.clear();
  lcd.print("      IoT  ");
  lcd.setCursor(0,1);
  delay(3000);
  lcd.print("    Project ");
  delay(3000);
  analogWrite(pwm, 255);
  lcd.clear();
  lcd.print("  Java and DBS ");
  lcd.setCursor(0,1); 
  delay(2000);
  lcd.clear(); 
}



void loop()
{
  float templcd=dht.readTemperature(true);  
  float hum = dht.readHumidity();
  Serial.println(hum);
  int sensorValue = analogRead(A0);   // read the input on analog pin 0
  float Vout = (sensorValue * (5.0/1023));
  //float RLDR = (10000.0 * (5 - Vout))/Vout;
  //float lux = 500/RLDR;
  int lux = 100*Vout - 152;
  int fanSpeed = 100;  
  Serial.println("Lux" + String(lux) + ", Vout" + String(Vout));   // print out the value you read
  templcd=((templcd-32)*5)/9;
  int temp=templcd;
   if(temp <26 )
    { 
      analogWrite(pwm,0);
      lcd.print("Fan OFF            ");
      fanSpeed = 0;
    }
    
    else if(temp==26)
    {
      analogWrite(pwm, 122);
      lcd.print("Fan Speed: 20%   ");
      fanSpeed = 20;
    }
    
     else if(temp==27)
    {
      analogWrite(pwm, 245);
      lcd.print("Fan Speed: 40%   ");
      fanSpeed = 40;
    }
    
     else if(temp==28)
    {
      analogWrite(pwm, 367);
      lcd.print("Fan Speed: 60%   ");
      fanSpeed = 60;
    }
    
    else if(temp==29)
    {
      analogWrite(pwm, 490);
      lcd.print("Fan Speed: 80%    ");
      fanSpeed = 80;
    }
     else if(temp>29)
    {
      analogWrite(pwm, 613);
      lcd.print("Fan Speed: 100%   ");
      fanSpeed = 100;
    } 
  HTTPClient http;    //Declare object of class HTTPClient
  String ADCData, station, postData;
  ADCData = String(templcd);   //String to interger conversion
  station = "A";
  Serial.println(ADCData);
  //Post Data
  postData = "?temp=" + ADCData + "&humidity=" + String(hum) + "&lux=" + String(lux) + "&fanSpeed=" + String(fanSpeed);
  http.begin("http://192.168.0.123:8080/IoTServlet2/DataFetcher"+postData);              //Specify request destination
 // http.addHeader("Content-Type", "application/x-www-form-urlencoded");    //Specify content-type header
  int httpCode=http.GET();
  //int httpCode = http.POST(postData);   //Send the request
  String payload = http.getString();    //Get the response payload
 
  Serial.println(httpCode);   //Print HTTP return code
  Serial.println(payload);    //Print request response payload
 
  http.end();  //Close connection
  
  delay(3000);  //Post Data at every 5 seconds
  
  lcd.setCursor(0,0);
  lcd.print("Temperature:");
  lcd.print(templcd);   // Printing temperature on LCD
  //lcd.write(1);
  //lcd.print("C");
  lcd.setCursor(0,1);
 
  delay(1100);
}
