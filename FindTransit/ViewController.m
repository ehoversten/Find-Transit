//
//  ViewController.m
//  FindTransit
//
//  Created by Erik Hoversten on 18.07.15.
//  Copyright (c) 2015 EverProductions. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "SearchManager.h"
#import "DetailViewController.h"


@interface ViewController ()

@property (nonatomic, strong) AppDelegate       *appDelegate;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) Reachability      *hostReach;
@property (nonatomic, strong) Reachability      *internetReach;
@property (nonatomic, strong) Reachability      *wifiReach;
@property (nonatomic, strong) SearchManager     *goSearch;

@property (nonatomic, strong) NSString           *hostName;
@property (nonatomic, strong) NSString           *stationName;
@property (nonatomic, strong) NSString           *trainLineName;
@property (nonatomic, strong) NSArray            *metroArray;
@property (nonatomic, strong) NSArray            *bikeArray;
@property (nonatomic, strong) NSArray            *stationArray;
@property (nonatomic, strong) NSArray            *busArray;

@property (nonatomic, strong) IBOutlet MKMapView *transitMapView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem  *sendLocationButton;
@property (nonatomic, strong) IBOutlet UITableView *metroTableView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *travelSeg;
@property (nonatomic, strong) IBOutlet UIButton  *mapButton;

@end

@implementation ViewController

// Variables for Reachability
BOOL internetAvailable;
BOOL serverAvailable;


#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_travelSeg.selectedSegmentIndex == 0) {
        return _metroArray.count;
    } else if (_travelSeg.selectedSegmentIndex == 1) {
        return _bikeArray.count;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (_travelSeg.selectedSegmentIndex == 0) {
        NSDictionary *nearStation = [_metroArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [nearStation objectForKey:@"name"];
        cell.detailTextLabel.text = [nearStation objectForKey:@"address"];
    } else if (_travelSeg.selectedSegmentIndex == 1) {
        NSDictionary *nearBike = [_bikeArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [nearBike objectForKey:@"name"];
        NSArray *bikesAvailArray = [nearBike objectForKey:@"nbBikes"];
        NSArray *bikesOpenSpaces = [nearBike objectForKey:@"nbEmptyDocks"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Available Bikes: %@   Open Spaces: %@", bikesAvailArray, bikesOpenSpaces];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected");
    if (_travelSeg.selectedSegmentIndex == 0) {
        [self performSegueWithIdentifier:@"listToDetailSegue" sender:self];
    } else {
        [_metroTableView deselectRowAtIndexPath:[_metroTableView indexPathForSelectedRow] animated:true];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"listToDetailSegue"])      {
        DetailViewController *destController = [segue destinationViewController];
        NSIndexPath *indexPath = [_metroTableView indexPathForSelectedRow];
        if (_travelSeg.selectedSegmentIndex == 0) {
            NSDictionary *line = [_metroArray objectAtIndex:indexPath.row];
            destController.nearStation = line;
        }
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section  {
    if (_travelSeg.selectedSegmentIndex == 0) {
        return @"Metro Stations";
    } else if (_travelSeg.selectedSegmentIndex == 1)  {
        return @"Bike Share";
    } else {
        return @"Error";
    }
}



- (void)dataReceived:(NSNotification *)flag {    
    [_metroTableView reloadData];
}


#pragma mark - Interactivity Methods

- (IBAction)sendMapViewButton:(id)sender  {

}

- (IBAction)sendLocationButton:(id)sender {

    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
    
    
    NSURL *fileURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@/?lat=%f&long=%f", _hostName, [[[_appDelegate goSearch] latitude] floatValue],[[[_appDelegate goSearch] longitude] floatValue]]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:fileURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    
    // this code gets ran in the BACKGROUND thread
    [NSURLConnection sendAsynchronousRequest: urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (([data length] > 0) && (error == nil)) {

            NSError *jsonError;
            NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            _metroArray = [(NSDictionary *) json objectForKey:@"station"];
            _bikeArray = [(NSDictionary *) json objectForKey:@"bike"];
            _busArray = [(NSDictionary *) json objectForKey:@"buses"];

            
            dispatch_async(dispatch_get_main_queue(), ^{  // go back to the Main (foreground) Thread
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
                [_metroTableView reloadData];       // will refresh the TableView
                if (_travelSeg.selectedSegmentIndex == 0) {
                    [self annotateMapLocations:_metroArray];
                } else if (_travelSeg.selectedSegmentIndex == 1) {
                    [self annotateMapLocations:_bikeArray];
                }

                [_transitMapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
            
            });
        }
    }];
    
    
    
}


#pragma mark - Connectivity Methods

- (void)updateReachabilityStatus:(Reachability *)curReach {
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if(curReach == _hostReach) {
        switch (netStatus) {
            case NotReachable:
            {
                NSLog(@"Server not Available");
                serverAvailable = false;
                break;
            }
            case ReachableViaWiFi:
            {
                NSLog(@"Server Reachable via WiFi");
                serverAvailable = true;
            }
            case ReachableViaWWAN:
            {
                NSLog(@"Server Reachable vie WWAN");
                serverAvailable = true;
            }
            default:
                break;
        }
    }


if(curReach == _internetReach || curReach == _wifiReach)  {
    switch (netStatus)  {
        case NotReachable:
        {
            NSLog(@"Internet not Available");
            internetAvailable = false;
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"Reachable via WWAN");
            internetAvailable = true;
            break;
        }
        {
        case ReachableViaWiFi:
            NSLog(@"Reachable via WiFi");
            internetAvailable = true;
            break;
        }
        default:
            NSLog(@"default");
            break;
        }
    }

}


- (void)reachabilityChanged:(NSNotification *)note   {
    Reachability *curReach = [note object];
    [self updateReachabilityStatus: curReach];
}
#pragma mark - Map Methods

- (void)zoomToLocationWithLat:(float)latitude andLon:(float)longitude {
    if (latitude == 0 && longitude == 0) {
        NSLog(@"Bad Coordinates");
    } else {
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = latitude;
        zoomLocation.longitude = longitude;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1200, 1200);
        MKCoordinateRegion adjustedRegion = [_transitMapView regionThatFits:viewRegion];
        [_transitMapView setRegion:adjustedRegion animated:true];
    }
}

- (void)annotateMapLocations:(NSArray *)locArray {
    NSMutableArray *locs = [[NSMutableArray alloc] init];
    for (id <MKAnnotation> annot in [_transitMapView annotations]) {
        if ([annot isKindOfClass:[MKPointAnnotation class]]) {
            [locs addObject:annot];
        }
    }
    [_transitMapView removeAnnotations:locs];       // remove pins
    
    NSMutableArray *annotionArray = [[NSMutableArray alloc] init];
    for (NSDictionary *loc in locArray) {
        MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
        pa.coordinate = CLLocationCoordinate2DMake([[loc objectForKey:@"latitude"] floatValue], [[loc objectForKey:@"longitude"] floatValue]);
        pa.title = [loc objectForKey:@"name"];
        [annotionArray addObject:pa];
    }
    [_transitMapView addAnnotations:annotionArray];  // adds annotations to the mapView
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation != mapView.userLocation) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
            annotationView.canShowCallout = true;
            annotationView.pinColor = MKPinAnnotationColorRed;
            annotationView.animatesDrop = true;
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

#pragma mark - Location Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *previousLocation = locations.lastObject;
    NSLog(@"%f, %f", previousLocation.coordinate.latitude, previousLocation.coordinate.longitude);
    
    // bring in SearchManager object and set Latitude and Longitude
    [_goSearch setLatitude:[NSNumber numberWithFloat:previousLocation.coordinate.latitude]];
    [_goSearch setLongitude:[NSNumber numberWithFloat:previousLocation.coordinate.longitude]];
    [self zoomToLocationWithLat:previousLocation.coordinate.latitude andLon:previousLocation.coordinate.longitude];
    
    [_locationManager stopUpdatingLocation];
    
}



- (void)turnOnLocationMonitoring {
    [_locationManager startUpdatingLocation];
    _transitMapView.showsUserLocation = true;
}


- (void)setupLocationMonitoring {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorizedAlways: {
                [self turnOnLocationMonitoring];
                break;
            }
            case kCLAuthorizationStatusAuthorizedWhenInUse: {
                [self turnOnLocationMonitoring];
                break;
            }
            case kCLAuthorizationStatusDenied: {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Denied!" message:@"You turned off our location access??" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                break;
            }
            case kCLAuthorizationStatusNotDetermined: {
                if ([_locationManager respondsToSelector:@selector (requestWhenInUseAuthorization)]) {
                    [_locationManager requestWhenInUseAuthorization];
                }
                break;
            }
            default:
                break;
        }
    } else {
        NSLog(@"Geht Nicht!");
    }
}

#pragma mark - Listener Methods

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _goSearch = _appDelegate.goSearch;
    _goSearch = [SearchManager shareSearch];
    [self setupLocationMonitoring];  // check to see if we have a connection available
    
    
    _hostName = @"transit-on-rails.herokuapp.com";   // data host
    
    // Listener Code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    // Reciever Code - can we connect to _hostName? / Is SERVER available?
    _hostReach = [Reachability reachabilityWithHostName:_hostName];
    [_hostReach startNotifier];
    [self updateReachabilityStatus:_hostReach];
    
    // is INTERNET available?
    _internetReach = [Reachability reachabilityForInternetConnection];
    [_internetReach startNotifier];
    [self updateReachabilityStatus:_internetReach];
    
    // IS WI-FI available?
    _wifiReach = [Reachability reachabilityForLocalWiFi];
    [_wifiReach startNotifier];
    [self updateReachabilityStatus:_wifiReach];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReceived:) name:@"ResultsDoneNotification" object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
