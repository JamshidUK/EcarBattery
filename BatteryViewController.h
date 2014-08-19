//
//  BatteryViewController.h
//  EcarMap
//
//  Created by Jamshid Ummattam Kuzhiyil on 17/02/14.
//  Copyright (c) 2014 Hochschule (Fakultaet Elektrotechnik und Informatik). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BatteryViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong)  IBOutlet  MKMapView *mapView;
@property (nonatomic, weak) id <MKMapViewDelegate> mapDelegate;
@property (nonatomic, strong)  IBOutlet  UILabel *circleRad;
@property (nonatomic)  double circleRadius;

- (IBAction)zoomIn:(id)sender;
- (IBAction)changeMapType:(id)sender;
- (IBAction)cancel:(id)sender;

@end
