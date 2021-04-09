struct IRQ {
  short addr_low;
  short segment;
  char reserved;
  char attr;
  short addr_high;
} __attribute__ ((__packed__));

extern struct IRQ idt_start[];
extern void load_idt();

extern void isr32(void);
extern void isr33(void);
