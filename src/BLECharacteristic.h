//
//  BLECharacteristic.h
//  bleDeviceDemo
//
//  Created by Joshua Noble on 3/29/15.
//
//

#ifndef bleDeviceDemo_BLECharacteristic_h
#define bleDeviceDemo_BLECharacteristic_h

#import <Foundation/Foundation.h>

@interface BLECharacteristic : NSObject
{
    NSString *uuid;
    bool shouldNotify;
}

- (void)setId:(NSString *)thisId;

@property (strong, atomic) NSString *uuid;
@property bool shouldNotify;

@end

#endif
