#include "serial_util.h"
#include <util/delay.h>
#include <avr/io.h>
#include <stdlib.h>

int main(void)
{
  _delay_ms(1000);
  serial_init();
  _delay_ms(1000);

  DDRB |= (1 << PB7);

  while(1)
  {
    PORTB |= (1 << PB7);
    serial_println("led on");
    _delay_ms(3000);

    PORTB &= ~(1 << PB7);
    serial_println("led off");
    _delay_ms(3000);
  }

  return 0;
}