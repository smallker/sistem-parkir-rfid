#include <Arduino.h>
#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#define RX_NODE D1
#define TX_NODE D2
#define SSID "bolt"
#define PASS "11111111"
#define URL "http://192.168.43.44:3000/"

SoftwareSerial ard(RX_NODE, TX_NODE);
HTTPClient http;
int no_pasien;
void setup()
{
  Serial.begin(9600);
  ard.begin(9600);
  WiFi.begin(SSID, PASS);
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(500);
  }
  Serial.println("\nSTARTED");
}

void loop()
{
  if (ard.available() > 0)
  {
    String data = ard.readString();
    if (data.charAt(0) == 'f'){
      Serial.println("frekuensi");
      if(data.charAt(1) == '0'){
        data.remove(0,2);
        Serial.println(data);
        http.begin((String)URL+"tbw");
        http.addHeader("content-type","application/json");
        http.POST("{\"no_pasien\":"+(String)no_pasien+",\"tbw\":"+data+"}");
      }
      else
      {
        data.remove(0,2);
        Serial.println(data);
        http.begin((String)URL+"ecw");
        http.addHeader("content-type","application/json");
        http.POST("{\"no_pasien\":"+(String)no_pasien+",\"ecw\":"+data+"}");
      }
      ard.print("f");
      ard.write(13);
    }
    if (data.charAt(0) == 'd')
    {
      Serial.println("data");
      data.remove(0, 1);
      Serial.println(data);
      no_pasien = data.toInt();
      http.begin((String)URL+"getperson");
      http.addHeader("content-type", "application/json");
      int rescode = http.POST("{\"no_pasien\":" + data + "}");
      if (rescode == HTTP_CODE_OK)
      {
        String http_data = http.getString();
        Serial.println(http_data);
        ard.print(http_data);
        ard.write(13);
      }
      else
      {
        Serial.println(http.getString());
        ard.print("na");
        ard.write(13);
      }
    }
  }
  delay(10);
}