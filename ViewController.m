//
//  ViewController.m
//  EcarMap
//
//  Created by Jamshid Ummattam Kuzhiyil on 12/02/14.
//  Copyright (c) 2014 Hochschule (Fakultaet Elektrotechnik und Informatik). All rights reserved.
//

#import "ViewController.h"
#import "BatteryViewController.h"
#import "BatteryView.h"

//@interface ViewController ()

//@end

@implementation ViewController

@synthesize battery, batteryLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Custom controller code

- (void)disableAnimation {
    self.battery.animate = NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    bleShield = [[BLE alloc] init];
    [bleShield controlSetup];
    bleShield.delegate = self;
    
    self.label.hidden = YES;
    self.labelRSSI.hidden = YES;
    self.labelRSSIText.hidden = YES;
    self.buttonConnect.hidden = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2013.png"]];
    //self.navigationController.navigationBar.translucent = NO;
    self.battery.hidden = YES;
    self.labelRangeText.hidden = YES;
    self.labelTempText.hidden = YES;
    self.labelPoint1Text.hidden = YES;
    self.labelTemp2Text.hidden = YES;
    self.labelTemp3Text.hidden = YES;
    self.labelTemp1Value.hidden = YES;
    self.labelTemp2Value.hidden = YES;
    self.labelTemp3Value.hidden = YES;
    self.batteryLabel.hidden = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.title = @"";
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.title = @"";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.battery = nil;
    self.batteryLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

// Called when scan period is over to connect to the first found peripheral
-(void) connectionTimer:(NSTimer *)timer
{
    if(bleShield.peripherals.count > 0)
    {
        [bleShield connectPeripheral:[bleShield.peripherals objectAtIndex:0]];
    }
    else
    {
        [self.spinner stopAnimating];
    }
}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [NSString stringWithFormat:@"%@", d];
    NSLog(@"Number value a %@", s);
    NSString *str1 = [s substringWithRange:NSMakeRange(1, 4)];
    NSLog(@"Number value a %@", str1);
    NSString *str2 = [s substringWithRange:NSMakeRange(5, 4)];
    NSLog(@"Number value a %@", str2);
    NSString *str3 = [s substringWithRange:NSMakeRange(10, 4)];
    NSLog(@"Number value a %@", str3);
    NSString *str4 = [s substringWithRange:NSMakeRange(14, 4)];
    NSLog(@"Number value a %@", str4);
    NSString *str5 = [s substringWithRange:NSMakeRange(19, 4)];
    NSLog(@"Number value a %@", str5);
    
    //Scanning the battery voltage value
    NSScanner *scanner1 = [NSScanner scannerWithString:str1];
    unsigned result1 = 0;
    [scanner1 setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    [scanner1 scanHexInt:&result1];
    NSLog(@"Number value a %d", result1);
    double batteryCharge = 0.0;
    double rangeDiff = 92.0 - 65.0;
    
    //Scanning the ampere hour value
    NSScanner *scanner2 = [NSScanner scannerWithString:str2];
    unsigned result2 = 0;
    [scanner2 setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    [scanner2 scanHexInt:&result2];
    NSLog(@"Number value a %d", result2);
    
    // Minimum safe discharge voltage for a cell is 2.7 V and maximum charge voltage is 4 V. So the total minimum voltage limit is taken as 65 V and maximum voltage limit as 92 V.
    if (result1 <= 65) {
        batteryCharge = 0.0;
        self.battery.currentValue = batteryCharge;
        if (result2 == 1) {
            self.batteryLabel.text = [NSString stringWithFormat: @"0%% Charging"];
        }
        else {
            self.batteryLabel.text = [NSString stringWithFormat: @"Battery Empty"];
        }
    } else if (result1 >= 92) {
        batteryCharge = 100.0;
        self.battery.currentValue = batteryCharge;
        self.batteryLabel.text = [NSString stringWithFormat: @"Battery Full"];
    } else {
        // Standard allowed voltage range
        batteryCharge = (result1 - 65.0)* (100.0/rangeDiff);
        self.battery.currentValue = batteryCharge;
        if (result2 == 1) {
            self.batteryLabel.text = [NSString stringWithFormat: @"%lu%% Charging", (unsigned long)self.battery.currentValue];
        }
        else if (result2 == 0){
            self.batteryLabel.text = [NSString stringWithFormat: @"%lu%% Charged", (unsigned long)self.battery.currentValue];
        }
    }
    
    NSLog(@"Number value a %.2f", batteryCharge);
    
    //Nominal battery capacity is 160 AmpereHour when battery is fully chrged and we assume that it can provide a range of 120 Km under normal driving conditions.
    double totalWattHours = rangeDiff * 160.0;
    double currentWattHours = (result1 - 65.0) * 160.0;
    double batteryRange = currentWattHours * (120.0/totalWattHours);
    self.label.text = [NSString stringWithFormat:@"%.2f km", batteryRange];
    
    //Don't perform an animation every time the battery level changes
    [self performSelector: @selector(disableAnimation) withObject: self afterDelay: 1.5];
    
    self.labelRangeText.hidden = NO;
    self.label.hidden = NO;

    
    self.labelTempText.hidden = NO;
    self.labelPoint1Text.hidden = NO;
    self.labelTemp1Value.hidden = NO;
    
    //Scanning the temperature value at point 1 of the car battery
    NSScanner *scanner3 = [NSScanner scannerWithString:str3];
    unsigned result3 = 0;
    [scanner3 setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    [scanner3 scanHexInt:&result3];
    double batteryTemp1 = result3 / 100.0;
    self.labelTemp1Value.text = [NSString stringWithFormat:@"%.2f ° Celsius", batteryTemp1];

    self.labelTemp2Text.hidden = NO;
    self.labelTemp2Value.hidden = NO;
    
    //Scanning the temperature value at point 2 of the car battery
    NSScanner *scanner4 = [NSScanner scannerWithString:str4];
    unsigned result4 = 0;
    [scanner4 setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    [scanner4 scanHexInt:&result4];
    double batteryTemp2 = result4 / 100.0;
    self.labelTemp2Value.text = [NSString stringWithFormat:@"%.2f ° Celsius", batteryTemp2];
    
    self.labelTemp3Text.hidden = NO;
    self.labelTemp3Value.hidden = NO;

    //Scanning the temperature value at point 3 of the car battery
    NSScanner *scanner5 = [NSScanner scannerWithString:str5];
    unsigned result5 = 0;
    [scanner5 setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    [scanner5 scanHexInt:&result5];
    double batteryTemp3 = result5 / 100.0;
    self.labelTemp3Value.text = [NSString stringWithFormat:@"%.2f ° Celsius", batteryTemp3];
}

NSTimer *rssiTimer;

-(void) readRSSITimer:(NSTimer *)timer
{
    [bleShield readRSSI];
}

- (void) bleDidDisconnect
{
    if (bleShield.activePeripheral)
        if(bleShield.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[bleShield CM] cancelPeripheralConnection:[bleShield activePeripheral]];
        }
    
    [rssiTimer invalidate];
    [self viewDidLoad];
}

-(void) bleDidConnect
{
    [self.spinner stopAnimating];
    
    self.buttonConnect.hidden = YES;
    
    self.labelRSSI.hidden = NO;
    self.labelRSSIText.hidden = NO;
    self.battery.hidden = NO;
    self.batteryLabel.hidden = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.title = @"Map";
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem.title = @"close";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2048.png"]];
    
    // Schedule to read RSSI every 1 sec.
    rssiTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];
    
    //self.battery.currentValue = 60;
}

-(void) bleDidUpdateRSSI:(NSNumber *)rssi
{
    self.labelRSSI.text = rssi.stringValue;
}

- (IBAction)bleShieldScan:(id)sender
{
    if (bleShield.activePeripheral)
        if(bleShield.activePeripheral.state == CBPeripheralStateConnected)
        {
            [self bleDidDisconnect];
            return;
        }
    
    if (bleShield.peripherals)
        bleShield.peripherals = nil;
    
    [bleShield findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    [self.spinner startAnimating];
}

-(void) bleCancelButton:(id)sender
{
    [self bleDidDisconnect];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Map"]) {
        
        //UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        //BatteryViewController *batteryViewController = [[navigationController viewControllers] lastObject];
        BatteryViewController *batteryViewController = (BatteryViewController *) segue.destinationViewController;
        batteryViewController.circleRad = self.label;
        NSLog(@"Segue value %@", batteryViewController.circleRad.text);
        NSLog(@"Segue value %@", self.label.text);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

@end
