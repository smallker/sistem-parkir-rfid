#include <Arduino.h>
#include <LiquidCrystal_I2C.h>
#include <Keypad.h>
#include <SoftwareSerial.h>
#include <TimerOne.h>
#define RX_ARD 3
#define TX_ARD 2
#define SENSOR_PIN A0
SoftwareSerial node(3, 2);
LiquidCrystal_I2C lcd(0x27, 16, 2);
const byte ROWS = 4; //four rows
const byte COLS = 3; //three columns
char keys[ROWS][COLS] = {
    {'1', '2', '3'},
    {'4', '5', '6'},
    {'7', '8', '9'},
    {'*', '0', '#'}};
byte rowPins[ROWS] = {11, 10, 9, 8};
byte colPins[COLS] = {7, 6, 5};
Keypad kpd = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);
unsigned long loopCount = 0;
unsigned long timer_t = 0;
char buff[5];
int count;
char key;
volatile bool sent, sentfreq, is5Khz, reset;

String serialData;
float I = 0.2, V;
int W, H, A, Z;
float tbw, ecw;

void readKeypad()
{
  key = kpd.getKey();
  if (key == '#')
    sent = true;
  if (key == '*')
  {
    sent = false;
    sentfreq = false;
    is5Khz = false;
    reset = true;
  }
  if (key && key != '#' && key != '*')
  {
    buff[count] = key;
    count++;
  }
}
void measure(String data)
{
  char string[data.length() + 1];
  data.toCharArray(string, data.length() + 1);
  char *token = strtok(string, ",");
  int arr[4];
  int c;
  while (token != NULL)
  {
    arr[c] = atoi(token);
    c++;
    token = strtok(NULL, ",");
  }
  /*
    sampling 20 data, ganti delay sesuai sampling rate yg dibutuhkan
  */
  float sampling;
  for (int i = 0; i < 20; i++)
  {
    float sensorReading = analogRead(SENSOR_PIN);
    sampling = sampling + sensorReading;
    Serial.println((String)i + " => " + (String)sensorReading);
    delay(20);
  }
  V = sampling / 20;
  Z = V / I;
  W = arr[0];
  H = arr[1];
  A = arr[2];
  if (is5Khz)
  {
    ecw = 2.53 + 0.118903 * H * H / Z + 0.06753 * W - 0.02 * A;
  }
  else
  {
    tbw = 6.53 + 0.36740 * H * H / Z + 0.17531 * W - 0.11 * A;
  }
  Serial.println("sampling : " + (String)sampling + " V : " + (String)V);
  Serial.println("berat : " + (String)W + " tinggi : " + (String)H + " usia : " + (String)A + " ecw : " + (String)ecw + " tbw : " + (String)tbw);
}
void setup()
{
  Serial.begin(9600);
  node.begin(9600);
  pinMode(SENSOR_PIN, INPUT);
  lcd.init();
  lcd.backlight();
  kpd.setDebounceTime(50);
  Timer1.initialize(1000);
  Timer1.attachInterrupt(readKeypad);
}
void loop()
{
  if (sentfreq)
  {
    lcd.setCursor(0, 0);
    lcd.print("Frekuensi :");
    lcd.setCursor(0, 1);
    lcd.print(buff);
  }
  else
  {
    lcd.setCursor(0, 0);
    lcd.print("No. Pasien :");
    lcd.setCursor(0, 1);
    lcd.print(buff);
  }

  if (sent)
  {
    if (sentfreq)
    {
      if (((String)buff) == "5")
      {
        is5Khz = true;
      }
      else
        is5Khz = false;
      measure(serialData);
      is5Khz ? node.print("f1" + (String)ecw) : node.print("f0" + (String)tbw);
    }
    else
    {
      lcd.clear();
      lcd.print("Tunggu . .");
      node.print("d" + (String)buff);
    }

    while (true)
    {
      if (node.available() > 0)
      {
        sentfreq = true;
        sent = false;
        serialData = node.readStringUntil(13);
        if (serialData.length() > 0)
        {
          lcd.clear();
          if (serialData == "na")
          {
            lcd.setCursor(0, 0);
            lcd.print("tidak ditemukan");
          }
          if (serialData == "f")
          {
            lcd.clear();
            lcd.setCursor(0, 0);
            is5Khz ? lcd.print("ECW : " + (String)ecw + " L") : lcd.print("TBW : " + (String)tbw + " L");
            while (true)
            {
              if (reset == true)
              {
                reset = false;
                break;
              }
            }
          }
          break;
        }
      }
    }
    count = 0;
    for (int i = 0; i < 5; i++)
    {
      buff[i] = 0;
    }
    lcd.clear();
  }
}