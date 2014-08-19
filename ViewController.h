//
//  ViewController.h
//  EcarMap
//
//  Created by Jamshid Ummattam Kuzhiyil on 12/02/14.
//  Copyright (c) 2014 Hochschule (Fakultaet Elektrotechnik und Informatik). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"
#import "BatteryViewController.h"

@class BatteryView;
@interface ViewController : UIViewController <BLEDelegate> {
    BLE *bleShield;
}

@property (weak, nonatomic)   IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic)   IBOutlet UIButton *buttonConnect;
@property (weak, nonatomic)   IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) IBOutlet UILabel *labelRSSI;
@property (nonatomic, strong) IBOutlet UILabel *labelRSSIText;
@property (nonatomic, strong) IBOutlet UILabel *labelRangeText;
@property (nonatomic, strong) IBOutlet UILabel *labelTempText;
@property (nonatomic, strong) IBOutlet UILabel *labelPoint1Text;
@property (nonatomic, strong) IBOutlet UILabel *labelTemp1Value;
@property (nonatomic, strong) IBOutlet UILabel *labelTemp2Text;
@property (nonatomic, strong) IBOutlet UILabel *labelTemp2Value;
@property (nonatomic, strong) IBOutlet UILabel *labelTemp3Text;
@property (nonatomic, strong) IBOutlet UILabel *labelTemp3Value;
@property (nonatomic, strong) IBOutlet UILabel *batteryLabel;
@property (nonatomic, strong) IBOutlet BatteryView *battery;

- (IBAction)bleShieldScan:(id)sender;
- (IBAction)bleCancelButton:(id)sender;

@end