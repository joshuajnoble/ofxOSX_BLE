//
//  ofxBLECharacteristic.h
//  bleDeviceDemo
//
//  Created by Joshua Noble on 3/29/15.
//
//

#ifndef ofxBLECharacteristic_h
#define ofxBLECharacteristic_h

#include <string>

class ofxBLECharacteristic {
    
public:
    bool shouldNotify;
    std::string UUID;
    
    ofxBLECharacteristic();
    
};



//@interface ofxBLECharacteristic : NSObject<CBPeripheralDelegate>
//{
//}
//
//@property bool *shouldNotify;
//@property std::string *UUID;
//
//- (void)init;

#endif
