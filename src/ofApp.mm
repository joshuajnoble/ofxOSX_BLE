#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){

    connected = false;
    
    ble = [[BLEDelegate alloc] init];
    [ble initialize];
    [ble setApplication:this];
}

void ofApp::exit(){

    [ble cleanup];
//    [ble close];
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
    if([ble isLECapableHardware])
    {
        [ble startScan];
    }
    else
    {
        cout << " uh oh, this computer won't work :( :( :( :( " << endl;
        exit();
    }
}

void ofApp::didDiscoverRFduino(CBPeripheral *rfduino)
{
    cout << " didDiscoverRFduino " << rfduino.name << endl;
    
    if( [[rfduino name] isEqualTo:@"JOSHS_RFDUINO"])
    {
         [ble connectDevice:rfduino];
//        ble->connectDevice(rfduino);
    }
}

void ofApp::didUpdateDiscoveredRFduino(CBPeripheral *rfduino)
{
    cout << " didUpdateDiscoveredRFduino " << endl;
}

void ofApp::didConnectRFduino(CBPeripheral *rfduino)
{
    cout << " didConnectRFduino " << endl;
    connected = true;
}

void ofApp::didLoadServiceRFduino(CBPeripheral *rfduino)
{
    cout << " didLoadServiceRFduino " << endl;
}

void ofApp::didDisconnectRFduino(CBPeripheral *rfduino)
{
    cout << " didDisconnectRFduino " << endl;
}

void ofApp::receivedData( unsigned char *data)
{
    cout << " got some data! " << endl;
    
    unsigned char reply[] = { 'h', 'i' };
    
    [ble send:reply len:2];
    
}
