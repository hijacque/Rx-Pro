const serialGSM = require('serialport-gsm');

const modem = serialGSM.Modem();
let options = {
    baudRate: 115200,
    dataBits: 8,
    stopBits: 1,
    parity: 'none',
    rtscts: false,
    xon: false,
    xoff: false,
    xany: false,
    autoDeleteOnReceive: true,
    enableConcatenation: true,
    incomingCallIndication: true,
    incomingSMSIndication: true,
    pin: '',
    customInitCommand: '',
    cnmiCommand: 'AT+CNMI=2,1,0,2,1',
    logger: console
};

modem.open('COM1', options, () => console.log('Modem opened.'));
modem.on('open', data => {
    modem.initializeModem(() => console.log('Modem initialized.'));
    modem.sendSMS('639458301808', 'Hello! Testing usb modem.', true, (data) => {
        console.log(data);
    });
});