//
//  ofxRFduinoApp.h
//  rfduino
//
//  Created by Joshua Noble on 8/5/14.
//
//

#ifndef rfduino_ofxRFduinoApp_h
#define rfduino_ofxRFduinoApp_h

#import <IOBluetooth/IOBluetooth.h>
//#import <CoreBluetooth/CoreBluetooth.h>
#import "ofxBLECharacteristic.h"
#import "BLECharacteristic.h"
#import <vector>

class ofxOSXBleApp
{
public:
    virtual void didDiscoverBLEDevice(CBPeripheral * cb) = 0;
    virtual void didUpdateDiscoveredBLEDevice(CBPeripheral * cb) = 0;
    virtual void didConnectBLEDevice(CBPeripheral * cb) = 0;
    virtual void didLoadServiceBLEDevice(CBPeripheral * cb) = 0;
    virtual void didDisconnectBLEDevice(CBPeripheral *cb) = 0;
    
    virtual void receivedData( unsigned char *data) = 0;
    virtual void onBluetooth() = 0;
    
    NSMutableArray *createCharacteristics(std::vector<ofxBLECharacteristic>& charas)
    {
        
        NSMutableArray *mm = [[NSMutableArray alloc] init];
        
        
        for( int i = 0; i < charas.size(); i++ ) {
            
            //NSString *uuid = [NSString stringWithCString:charas.at(i).UUID.c_str() encoding:[NSString defaultCStringEncoding]];
            BLECharacteristic *b = [[BLECharacteristic alloc] init];
            NSString* nsstring = [NSString stringWithUTF8String:charas.at(i).UUID.c_str()];
            [b setId:nsstring];
            b.shouldNotify = charas.at(i).shouldNotify;
            
            
            [mm addObject:b];
        }
        
        return mm;
    }
    
    NSString* createNSString(std::string& s)
    {
        NSString* nstring = [NSString stringWithUTF8String:s.c_str()];
        return nstring;
    }
    
};
#endif
