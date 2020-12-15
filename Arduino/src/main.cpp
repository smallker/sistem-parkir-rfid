#include <Arduino.h>
#include <SoftwareSerial.h>
#include <SPI.h>
#include <MFRC522.h>
#include <LiquidCrystal_I2C.h>
#include <Servo.h>
#define RX_PIN 2
#define TX_PIN 3
#define RST_PIN 9
#define RFID_MASUK 10
#define RFID_KELUAR 8

#define SRV1_PIN 4
#define SRV2_PIN 5
#define NR_OF_READERS 2

#define MAX_CAPACITY 2
byte ssPins[] = {RFID_MASUK, RFID_KELUAR};

MFRC522 mfrc522[NR_OF_READERS];
SoftwareSerial data(RX_PIN, TX_PIN);
LiquidCrystal_I2C lcd(0x27, 16, 2);
Servo masuk;
Servo keluar;
int active_reader;
int jumlah_kendaraan;
void dump_byte_array(byte *buffer, byte bufferSize, int reader);

void setup()
{
  Serial.begin(9600); // Initialize serial communications with the PC
  data.begin(9600);
  masuk.attach(SRV1_PIN);
  keluar.attach(SRV2_PIN);
  masuk.write(0);
  keluar.write(0);
  SPI.begin(); // Init SPI bus
  for (uint8_t reader = 0; reader < NR_OF_READERS; reader++)
  {
    mfrc522[reader].PCD_Init(ssPins[reader], RST_PIN); // Init each MFRC522 card
    Serial.print(F("Reader "));
    Serial.print(reader);
    Serial.print(F(": "));
    mfrc522[reader].PCD_DumpVersionToSerial();
  }
  lcd.begin();
  lcd.setCursor(0, 0);
  lcd.print("=SISTEM  PARKIR=");
  lcd.setCursor(0, 1);
  lcd.print("    OTOMATIS    ");
  delay(2000);
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Max  : " + (String)MAX_CAPACITY);
  lcd.setCursor(0, 1);
  lcd.print("Sisa : " + (String)(MAX_CAPACITY - jumlah_kendaraan));
}

void loop()
{

  for (uint8_t reader = 0; reader < NR_OF_READERS; reader++)
  {
    if (mfrc522[reader].PICC_IsNewCardPresent() && mfrc522[reader].PICC_ReadCardSerial())
    {
      dump_byte_array(mfrc522[reader].uid.uidByte, mfrc522[reader].uid.size, reader);
      mfrc522[reader].PICC_HaltA();
      mfrc522[reader].PCD_StopCrypto1();
    }
  }
  if (data.available() > 0)
  {
    String readData = data.readStringUntil(1);
    lcd.clear();
    lcd.setCursor(0, 0);
    active_reader == 0 ? lcd.print("Masuk") : lcd.print("Keluar");
    lcd.setCursor(0, 1);
    lcd.print(readData);
    Serial.println("Jumlah kendaraan : " + (String)jumlah_kendaraan);
    if (readData.charAt(0) == 'S')
    {
      if (active_reader == 0)
      {
        jumlah_kendaraan++;
        masuk.write(90);
        delay(5000);
        masuk.write(0);
      }
      else
      {
        if (jumlah_kendaraan != 0)
        {
          jumlah_kendaraan--;
        }
        keluar.write(90);
        delay(5000);
        keluar.write(0);
      }
      lcd.clear();
    }
    else if (readData.charAt(0) == 'I')
    {
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print(readData);
      lcd.setCursor(0, 1);
      lcd.print("Belum terdaftar");
      delay(5000);
      lcd.clear();
    }
    else
    {
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print(readData);
      delay(5000);
      lcd.clear();
    }
    lcd.setCursor(0, 0);
    lcd.print("Max  : " + (String)MAX_CAPACITY);
    lcd.setCursor(0, 1);
    lcd.print("Sisa : " + (String)(MAX_CAPACITY - jumlah_kendaraan));
  }
}

void dump_byte_array(byte *buffer, byte bufferSize, int reader)
{
  active_reader = reader;
  Serial.println("\nReader : " + (String)reader + "\n");
  if (jumlah_kendaraan < MAX_CAPACITY || reader == 1)
  {
    data.print(reader);
    data.print(",");
    for (byte i = 0; i < bufferSize; i++)
    {
      Serial.print(buffer[i], HEX);
      data.print(buffer[i], HEX);
    }
    data.write(1);
  }
  else
  {
    lcd.clear();
    lcd.print("Sudah penuh");
  }
}