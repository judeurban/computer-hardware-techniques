l = [
    'PIN_W15',
    'PIN_AK2',
    'PIN_Y16',
    'PIN_AK3',
    'PIN_AJ1',
    'PIN_AJ2',
    'PIN_AH2',
    'PIN_AH3',
    'PIN_AH4',
    'PIN_AH5',
    'PIN_AG1',
    'PIN_AG2',
    'PIN_AG3',
    'PIN_AG5',
    'PIN_AG6',
    'PIN_AG7',
    'PIN_AG8',
    'PIN_AF4',
    'PIN_AF5',
    'PIN_AF6',
    'PIN_AF8',
    'PIN_AF9',
    'PIN_AF10',
    'PIN_AE7',
    'PIN_AE9',
    'PIN_AE11',
    'PIN_AE12',
    'PIN_AD7',
    'PIN_AD9',
    'PIN_AD10',
    'PIN_AD11',
    'PIN_AD12',
    'PIN_AC9',
    'PIN_AC12',
    'PIN_AB12',
    'PIN_AA12'
]

even_pins = l[0::2]
odd_pins = l[1::2]

for i, (odd_pin, even_pin) in enumerate(zip(odd_pins, even_pins)):
    print(f'GPIO_0[{2*i}]', even_pin, '|', odd_pin, f'GPIO_0[{2*i + 1}]')