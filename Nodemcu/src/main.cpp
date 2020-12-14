#include <Arduino.h>
#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#define RX_NODE D1
#define TX_NODE D2
#define SSID "bolt"
#define PASS "11111111"
const String BASE_URL = "http://192.168.43.44:3000/";

SoftwareSerial ard(RX_NODE, TX_NODE);
HTTPClient http;
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
    String data = ard.readStringUntil(1);
    Serial.println(data.charAt(0) == '0' ? "Masuk" : "Keluar");
    if (data.charAt(0) == '0')
    {
      data.remove(0, 2);
      http.begin(BASE_URL + "entry?rfid=" + (String)data);
    }
    else
    {
      data.remove(0, 2);
      http.begin(BASE_URL + "exit?rfid=" + (String)data);
    }
    Serial.println(data);
    int response = http.GET();
    if (response == HTTP_CODE_OK)
    {
      Serial.println(http.getString());
      ard.print("Saldo : " + http.getString());
      ard.write(1);
    }
    else if (response == HTTP_CODE_INTERNAL_SERVER_ERROR)
    {
      Serial.println("saldo habis");
      ard.print("saldo habis");
      ard.write(1);
    }
    else
    {
      Serial.println("Belum terdaftar");
      ard.print("ID: "+(String)data);
      ard.write(1);
    }
    http.end();
    }
  delay(10);
}