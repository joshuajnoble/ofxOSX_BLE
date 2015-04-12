
#import "BLEDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation BLEDelegate

@synthesize manufacturer;
@synthesize cachedServiceID;

- (void) close
{
    [self stopScan];
    
    [peripheral setDelegate:nil];
    [peripheral release];
    
    [bleDevices release];
    
    [manager release];
    
    [super dealloc];
}

- (void)cleanup
{
    // See if we are subscribed to a characteristic on the peripheral
    if (peripheral.services != nil) {
        for (CBService *service in peripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    //if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            // It is notifying, so unsubscribe
                            [peripheral setNotifyValue:NO forCharacteristic:characteristic];
                            
                            // And we're done.
                            return;
                        }
                    //}
                }
            }
        }
    }
    
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    if( peripheral != nil)
    {
        [manager cancelPeripheralConnection:peripheral];
    }
}


- (void) initialize
{
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    cachedServiceID = @"";
}

- (void) setApplication:( ofxOSXBleApp* )application
{
    app = application;
}

/*
 Disconnect peripheral when application terminate 
*/
- (void) applicationWillTerminate:(NSNotification *)notification
{
    if(peripheral)
    {
        [manager cancelPeripheralConnection:peripheral];
    }
}

- (void)setCharacteristics:(NSArray *)cs
{
    characteristics = cs;
}

- (void)setServiceID:(NSString *)serviceId;
{
    //deviceServiceId = [NSString alloc];
    
    deviceServiceId = [NSString stringWithString:serviceId];
}


#pragma mark - Start/Stop Scan methods

/*
 Uses CBCentralManager to check whether the current platform/hardware supports Bluetooth LE. An alert is raised if Bluetooth LE is not enabled or is not supported.
 */
- (BOOL) isLECapableHardware
{
    NSString * state = nil;
    
    switch ([manager state]) 
    {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            return TRUE;
        case CBCentralManagerStateUnknown:
        default:
            return FALSE;
            
    }
    
    return FALSE;
}

- (void) startScan:(NSString*) serviceID
{
    cachedServiceID = [[NSString alloc] init];
    cachedServiceID = [serviceID copy];
    NSLog(@"Looking for UUID: %@", cachedServiceID);
    [manager scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:serviceID]] options:nil];
}

/*
 Request CBCentralManager to stop scanning for heart rate peripherals
 */
- (void) stopScan 
{
    [manager stopScan];
}

- (void) connectDevice:(CBPeripheral *) aPeripheral
{
    peripheral = aPeripheral;
    [peripheral retain];
    [manager connectPeripheral:peripheral options:nil];
}


#pragma mark - CBCentralManager delegate methods
/*
 Invoked whenever the central manager's state is updated.
 */
- (void) centralManagerDidUpdateState:(CBCentralManager *)central 
{
    //[self isLECapableHardware];
    app->onBluetooth();
}

/*
 Invoked when the central discovers devices while scanning.
 */
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)aPeripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI 
{    
    //NSMutableArray *peripherals = [self mutableArrayValueForKey:@"bleDevices"];
//    if( ![self->bleDevices containsObject:aPeripheral] )
//    {
//        [peripherals addObject:aPeripheral];
//    }
    
    app->didDiscoverBLEDevice(aPeripheral);
    
//    [manager retrievePeripherals:[NSArray arrayWithObject:(id)aPeripheral.UUID]];
}

/*
 Invoked when the central manager retrieves the list of known peripherals.
 */
//- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
//{
//    //NSLog(@"Retrieved peripheral: %lu - %@", [peripherals count], peripherals);
//    
//    [self stopScan];
//    
//    /* If there are any known devices, automatically connect to it.*/
//    if([peripherals count] >=1)
//    {
//        for( CBPeripheral * p in peripherals )
//        {
//            app->didDiscoverBLEDevice(p);
//        }
//    }
//}

/*
 Invoked whenever a connection is succesfully created with the peripheral. 
 Discover available services on the peripheral
 */
- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral 
{    
    [aPeripheral setDelegate:self];
    [aPeripheral discoverServices:nil];
    
//    peripheral = aPeripheral;
//    [peripheral retain];
    
    app->didConnectBLEDevice(aPeripheral);

}

/*
 Invoked whenever an existing connection with the peripheral is torn down.
 Reset local variables
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{

    if( peripheral )
    {
        [peripheral setDelegate:nil];
        [peripheral release];
        peripheral = nil;
        
        app->didDisconnectBLEDevice(aPeripheral);
        
    }
}

/*
 Invoked whenever the central manager fails to create a connection with the peripheral.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    NSLog(@"Fail to connect to peripheral: %@ with error = %@", aPeripheral, [error localizedDescription]);
//    [connectButton setTitle:@"Connect"]; 
    if( peripheral )
    {
        [peripheral setDelegate:nil];
        [peripheral release];
        peripheral = nil;
    }
}

#pragma mark - CBPeripheral delegate methods

- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error 
{
    for (CBService *aService in aPeripheral.services) 
    {
        NSLog(@"Service found with UUID: %@", aService.UUID);
        
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:cachedServiceID]])
        //if([aService.UUID isEqual:[CBUUID UUIDWithString:@"713D0000-503E-4C75-BA94-3148F18D941E"]])
        {
            [aPeripheral discoverCharacteristics:nil forService:aService];
            app->didLoadServiceBLEDevice(aPeripheral);
        }
        
    }
}

- (void) send:( unsigned char *) data len:(int)length
{
    for (CBService *aService in peripheral.services)
    {
        if( [aService.UUID isEqual:[CBUUID UUIDWithString:cachedServiceID]])
        //if([aService.UUID isEqual:[CBUUID UUIDWithString:@"713D0000-503E-4C75-BA94-3148F18D941E"]])
        {
            for (CBCharacteristic *aChar in aService.characteristics)
            {
                /// BLEDevice send
//                if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2222"]])
//                {
//                    //[peripheral writeValue:data forCharacteristic:aChar type:CBCharacteristicWriteWithResponse];
//                    NSData *d = [NSData dataWithBytes:data length:length];
//                    [peripheral writeValue:d forCharacteristic:aChar type:CBCharacteristicWriteWithoutResponse];
//                }
                
                for( BLECharacteristic *chara in characteristics)
                {
                    CBUUID *uuid = [CBUUID UUIDWithString:(chara.uuid)];
                    if ([aChar.UUID isEqual:uuid]) {
                        NSData *d = [NSData dataWithBytes:data length:length];
                        [peripheral writeValue:d forCharacteristic:aChar type:CBCharacteristicWriteWithoutResponse];
                    }
                }
                
            }
        }
    }
}

- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{    


    for (CBService *service in peripheral.services) {
        
        CBUUID *tservice_uuid = [CBUUID UUIDWithString:cachedServiceID];
        //CBUUID *tservice_uuid = [CBUUID UUIDWithString:@"713D0000-503E-4C75-BA94-3148F18D941E"];
            
        if ([service.UUID isEqual:tservice_uuid]) {
            for (CBCharacteristic *characteristic in service.characteristics) {

                for( BLECharacteristic *chara in characteristics)
                {
                    CBUUID *uuid = [CBUUID UUIDWithString:(chara.uuid)];
                    if ([characteristic.UUID isEqual:uuid]) {
                        [peripheral setNotifyValue:chara.shouldNotify forCharacteristic:characteristic];
                    }
                }
            }
        }
    }

}

/*
 Invoked upon completion of a -[readValueForCharacteristic:] request or on the reception of a notification/indication.
 */
- (void) peripheral:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error 
{

    NSData * updatedValue = characteristic.value;
    uint8_t* dataPointer = (uint8_t*)[updatedValue bytes];
    app->receivedData(dataPointer);
}

@end
