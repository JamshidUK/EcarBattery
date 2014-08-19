//
//  BatteryViewController.m
//  EcarMap
//
//  Created by Jamshid Ummattam Kuzhiyil on 17/02/14.
//  Copyright (c) 2014 Hochschule (Fakultaet Elektrotechnik und Informatik). All rights reserved.
//

#import "BatteryViewController.h"
#import "ViewController.h"

@interface BatteryViewController ()

@end

@implementation BatteryViewController

@synthesize circleRad;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = YES;
    
    self.circleRadius = [self.circleRad.text doubleValue];
    NSLog(@"Number value new %.2f", self.circleRadius);
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"lat value %.2f", self.mapView.userLocation.location.coordinate.latitude);
    NSLog(@"long value %.2f", self.mapView.userLocation.location.coordinate.longitude);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)zoomIn:(id)sender {
    MKUserLocation *userLocation = self.mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (
                                        userLocation.location.coordinate, 20000, 20000);
    [self.mapView setRegion:region animated:NO];
}

- (IBAction)changeMapType:(id)sender {
    if (self.mapView.mapType == MKMapTypeStandard)	
        self.mapView.mapType = MKMapTypeSatellite;
    else
        self.mapView.mapType = MKMapTypeStandard;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    CLLocationDistance newRad = (CLLocationDistance) (self.circleRadius * 1000.0);
    NSLog(@"Number value new %.2f", newRad);
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:userLocation.location.coordinate radius:3000];
    [self.mapView addOverlay:circle];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
    renderer.strokeColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.1];
    renderer.lineWidth = 6.0;
    renderer.fillColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.1];
    renderer.alpha = .3;
    return renderer;
}

- (void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
