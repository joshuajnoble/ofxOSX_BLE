#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){

    connected = false;
    
    ble = [[BLEDelegate alloc] init];
    [ble initialize];
    [ble setApplication:this];
    
    string service = "713D0000-503E-4C75-BA94-3148F18D941E";
    [ble setServiceID:createNSString(service)];
    
    tx.UUID = "713D0003-503E-4C75-BA94-3148F18D941E";
    tx.shouldNotify = false;
    
    charas.push_back(tx);
    
    rx.UUID = "713D0002-503E-4C75-BA94-3148F18D941E";
    rx.shouldNotify = true;
    
    charas.push_back(rx);
    
    [ble setCharacteristics:createCharacteristics(charas)];
}

void ofApp::exit(){

    [ble cleanup];
}

//--------------------------------------------------------------
void ofApp::update(){

}

//--------------------------------------------------------------
void ofApp::draw(){

}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){
    
    unsigned char msg[] = { 'h', 'e', 'l', 'l', 'o' };
    [ble send:msg len:5];
}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}

void ofApp::onBluetooth()
{
    
    string serviceID = "713D0000-503E-4C75-BA94-3148F18D941E";
    
    if([ble isLECapableHardware])
    {
        [ble startScan:createNSString(serviceID)];
    }
    else
    {
        cout << " uh oh, this computer won't work :( :( :( :( " << endl;
        exit();
    }
}

void ofApp::didDiscoverBLEDevice(CBPeripheral *cb)
{
    cout << " didDiscoverBLEDevice " << cb.name << endl;
    
    if( [[cb name] isEqualTo:@"BLE_UART"])
    {
         [ble connectDevice:cb];
    }
}

void ofApp::didUpdateDiscoveredBLEDevice(CBPeripheral *cb)
{
    cout << " didUpdateDiscoveredBLEDevice " << endl;
}

void ofApp::didConnectBLEDevice(CBPeripheral *cb)
{
    cout << " didConnectBLEDevice " << endl;
    connected = true;
}

void ofApp::didLoadServiceBLEDevice(CBPeripheral *cb)
{
    cout << " didLoadServiceBLEDevice " << endl;
}

void ofApp::didDisconnectBLEDevice(CBPeripheral *cb)
{
    cout << " didDisconnectBLEDevice " << endl;
}

void ofApp::receivedData( unsigned char *data)
{
    cout << " got some data! " << endl;
    
    unsigned char reply[] = { 'h', 'i' };
    
    [ble send:reply len:2];
    
}
