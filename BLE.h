//
//  BLE.h
//  EcarMap
//
//  Created by Jamshid Ummattam Kuzhiyil on 12/02/14.
//  Copyright (c) 2014 Hochschule (Fakultaet Elektrotechnik und Informatik). All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <CoreBluetooth/CoreBluetooth.h>
#else
#import <IOBluetooth/IOBluetooth.h>
#endif

@protocol BLEDelegate
@optional
-(void) bleDidConnect;
-(void) bleDidDisconnect;
-(void) bleDidUpdateRSSI:(NSNumber *) rssi;
-(void) bleDidReceiveData:(unsigned char *) data length:(int) length;
@required
@end

@interface BLE : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate> {
    
}

@property (nonatomic,assign) id <BLEDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *peripherals;
@property (strong, nonatomic) CBCentralManager *CM;
@property (strong, nonatomic) CBPeripheral *activePeripheral;

-(void) enableReadNotification:(CBPeripheral *)p;
-(void) read;
-(void) writeValue:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data;

-(BOOL) isConnected;
-(void) write:(NSData *)d;
-(void) readRSSI;

-(void) controlSetup;
-(int) findBLEPeripherals:(int) timeout;
-(void) connectPeripheral:(CBPeripheral *)peripheral;

-(UInt16) swap:(UInt16) s;
-(const char *) centralManagerStateToString:(int)state;
-(void) scanTimer:(NSTimer *)timer;
-(void) printKnownPeripherals;
-(void) printPeripheralInfo:(CBPeripheral*)peripheral;

-(void) getAllServicesFromPeripheral:(CBPeripheral *)p;
-(void) getAllCharacteristicsFromPeripheral:(CBPeripheral *)p;
-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p;
-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service;

//-(NSString *) NSUUIDToString:(NSUUID *) UUID;
-(NSString *) CBUUIDToString:(CBUUID *) UUID;

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2;
-(int) compareCBUUIDToInt:(CBUUID *) UUID1 UUID2:(UInt16)UUID2;
-(UInt16) CBUUIDToInt:(CBUUID *) UUID;
-(BOOL) UUIDSAreEqual:(NSUUID *)UUID1 UUID2:(NSUUID *)UUID2;

@end
