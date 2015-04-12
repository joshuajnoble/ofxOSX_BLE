#pragma once

#include "ofMain.h"
#include "ofxOSXBleApp.h"
#import "BLEDelegate.h"

class ofApp : public ofBaseApp, public ofxOSXBleApp {

	public:

    void setup();
    void update();
    void draw();
    
    void keyPressed(int key);
    void keyReleased(int key);
    void mouseMoved(int x, int y);
    void mouseDragged(int x, int y, int button);
    void mousePressed(int x, int y, int button);
    void mouseReleased(int x, int y, int button);
    void windowResized(int w, int h);
    void dragEvent(ofDragInfo dragInfo);
    void gotMessage(ofMessage msg);
    void exit();
    
//    virtual void didDiscoverBLEDevice(CBPeripheral * cb) = 0;
//    virtual void didUpdateDiscoveredBLEDevice(CBPeripheral * cb) = 0;
//    virtual void didConnectBLEDevice(CBPeripheral * cb) = 0;
//    virtual void didLoadServiceBLEDevice(CBPeripheral * cb) = 0;
//    virtual void didDisconnectBLEDevice(CBPeripheral *cb) = 0;
//    
    
    void didDiscoverBLEDevice(CBPeripheral *cb);
    void didUpdateDiscoveredBLEDevice(CBPeripheral *cb);
    void didConnectBLEDevice(CBPeripheral *cb);
    void didLoadServiceBLEDevice(CBPeripheral *cb);
    void didDisconnectBLEDevice(CBPeripheral *cb);
    
    void receivedData( unsigned char *data);
    void onBluetooth();
    
    
    
    BLEDelegate *ble;
    bool connected;
    
    vector<ofxBLECharacteristic> charas;
    ofxBLECharacteristic rx;
    ofxBLECharacteristic tx;

};
