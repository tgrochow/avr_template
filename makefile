TARGET=avr_template
MCU=atmega2560
PROGRAMMER=wiring
PORT=/dev/ttyACM0
PBAUD=115200
SBAUD=9600

BINDIR=./bin
OBJDIR=./build
SRCDIR=./src
SOURCES=$(notdir $(wildcard $(SRCDIR)/*.c))
OBJECTS=$(addprefix $(OBJDIR)/, $(SOURCES:.c=.o))
CFLAGS=-I./include -c -Os
LDFLAGS=

all: project_structure hex

hex: $(BINDIR)/$(TARGET).hex

$(BINDIR)/$(TARGET).hex: $(BINDIR)/$(TARGET).elf
	avr-objcopy -O ihex -j .data -j .text $(BINDIR)/$(TARGET).elf \
	$(BINDIR)/$(TARGET).hex

$(BINDIR)/$(TARGET).elf: $(OBJECTS)
	avr-gcc $(LDFLAGS) -mmcu=$(MCU) $(OBJECTS) -o $(BINDIR)/$(TARGET).elf

$(OBJDIR)/%.o : $(SRCDIR)/%.c
	avr-gcc $(CFLAGS) -mmcu=$(MCU) $< -o $@

program: hex
	avrdude -p$(MCU) -P$(PORT) -B$(PBAUD) -c$(PROGRAMMER) \
	-Uflash:w:$(BINDIR)/$(TARGET).hex:a

project_structure:
	mkdir -p $(OBJDIR) $(BINDIR)

size:
	avr-size --mcu=$(MCU) -C $(BINDIR)/$(TARGET).elf

clean: clean_tmp clean_bin

clean_tmp:
	rm -rf $(OBJDIR)/*.o
	rm -rf $(BINDIR)/*.elf

clean_bin:
	rm -rf $(BINDIR)/*.hex

serial_monitor:
	stty -F $(PORT) cs8 $(SBAUD) ignbrk -brkint -icrnl -imaxbel -opost -onlcr \
	-isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon   \
	-crtscts
	clear
	tail -f $(PORT)

