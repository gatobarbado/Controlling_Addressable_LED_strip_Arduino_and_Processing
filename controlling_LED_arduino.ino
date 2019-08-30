#include <FastLED.h>

#define LED_PIN  6 //DATA PIN
#define NUM_LEDS 160   // AMOUNT OF LEDS

byte colores[160]; 
byte data[1000];


CRGB leds[NUM_LEDS]; //CREATING A PROPERTY REPRESENTING RGB COLOUR

void setup() { 
  
  FastLED.addLeds<WS2812B, LED_PIN, GRB>(leds, NUM_LEDS); //LIGHT STRIP TYPE, PIN USED, AMOUNT OF LED LIGHTS (GENERAL SETUP)
  Serial.begin(57600);
  establishContact();
}
  
void loop() {
  
 while (Serial.available() > 0) {
      if (Serial.read() == '*') {
        Serial.readBytes(data,480); //THIS STORES THE DATA SENT BY PROCESSING THROUGH THE SERIAL PORT
        
          /*for(int n=0; n<160; n++)
            {
                colores[n] =  data[n]; //THIS LINE READS THE DATA STORED IN THE BUFFER AND STORES IT INSIDE OF THE COLORES ARRAY
            }*/
            int c = 0;
          for(int k=0; k<160; k++)
            {
               leds [k] = CRGB(data[c],data[c+1],data[c+2]); //THIS LINE TAKES THE INDIVIDUAL RGB VALUES FROM THE DATA ARRAY AND GROUPS THEM AS RGB
               c+=3;
            }
          
          FastLED.show();
          //Serial.write('D');
      } 
       
  }
}
void establishContact()
{
    while(Serial.available() <= 0)
    {
    //Serial.println("C");
    delay(300);
    }
}
