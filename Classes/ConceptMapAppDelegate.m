//
//  ConceptMapAppDelegate.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright Cool Tool Apps 2010. All rights reserved.
//

#import "ConceptMapAppDelegate.h"
#import "ConceptMapViewController.h"
#import "Utility.h"

@implementation ConceptMapAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch. 
	if ([[DATABASE documents] count] <= 0) {
		Document *doc;
		Concept *concept;
		Concept *drives;
		Concept *edrives;
		Concept *idrives;
		Concept *ips;
		UIImage *image;
		
		doc = [DATABASE newDocumentTitled:@"doc 2"];
		image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image2" ofType:@"jpeg"]];
		doc.image = UIImageJPEGRepresentation(image, 1.0);

		concept = [DATABASE newConceptTitled:@"concept 3" toDocument:doc];
		concept.originX = [NSNumber numberWithInt: 300];
		concept.originY = [NSNumber numberWithInt: 300];
		concept.height = [NSNumber numberWithInt: 200];
		concept.width = [NSNumber numberWithInt: 200];
		concept.bodyDisplayString = @"body string";
		[DATABASE saveManagedObjectContext];
		
		doc = [DATABASE newDocumentTitled:@"doc 1"];
		image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image1" ofType:@"jpeg"]];
		doc.image = UIImageJPEGRepresentation(image, 1.0);

		concept = [DATABASE newConceptTitled:NSLocalizedString(@"Computer Template", @"") toDocument:doc];
		concept.originX = [NSNumber numberWithInt: 100];
		concept.originY = [NSNumber numberWithInt: 100];
		concept.height = [NSNumber numberWithInt: 300];
		concept.width = [NSNumber numberWithInt: 350];
		concept.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightBlue];
		concept.bodyDisplayString = NSLocalizedString(@"Power Comp - Windows Server 2008 SP 2", @"");
		
		drives = [DATABASE newConceptTitled:NSLocalizedString(@"Disk Drives", @"") toDocument:doc];
		drives.originX = [NSNumber numberWithInt: 85];
		drives.originY = [NSNumber numberWithInt: 50];
		drives.height = [NSNumber numberWithInt:150];
		drives.width = [NSNumber numberWithInt:200];
		drives.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantBlue];
		drives.bodyDisplayString = @" ";
		[concept addConcept:drives];
		
		idrives = [DATABASE newConceptTitled:NSLocalizedString(@"Internal Drives", @"") toDocument:doc];
		idrives.originX = [NSNumber numberWithInt: 10];
		idrives.originY = [NSNumber numberWithInt: 20];
		idrives.height = [NSNumber numberWithInt:50];
		idrives.width = [NSNumber numberWithInt:180];
		idrives.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightGreen];
		idrives.bodyDisplayString = NSLocalizedString(@"300gb - SATA", @"");
		[drives addConcept:idrives];
		
		edrives = [DATABASE newConceptTitled:NSLocalizedString(@"External Drives", @"") toDocument:doc];
		edrives.originX = [NSNumber numberWithInt: 10];
		edrives.originY = [NSNumber numberWithInt: 75];
		edrives.height = [NSNumber numberWithInt:50];
		edrives.width = [NSNumber numberWithInt:180];
		edrives.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightGreen];
		edrives.bodyDisplayString = NSLocalizedString(@"RAID - 3tb", @"");
		[drives addConcept:edrives];
		
		ips = [DATABASE newConceptTitled:NSLocalizedString(@"IP Addresses", @"") toDocument:doc];
		ips.originX = [NSNumber numberWithInt: 85];
		ips.originY = [NSNumber numberWithInt: 205];
		ips.height = [NSNumber numberWithInt:70];
		ips.width = [NSNumber numberWithInt:200];
		ips.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantBlue];
		ips.bodyDisplayString = NSLocalizedString(@"192.168.1.17\n192.168.12.11", @"");
		[concept addConcept:ips];

		concept = [DATABASE newConceptTitled:@"Features to Add" toDocument:doc];
		concept.originX = [NSNumber numberWithInt: 320];
		concept.originY = [NSNumber numberWithInt: 320];
		concept.height = [NSNumber numberWithInt: 300];
		concept.width = [NSNumber numberWithInt: 300];
		concept.colorSchemeConstant = [NSNumber numberWithInt:2];
		concept.bodyDisplayString = @"Connection objects\nCleanup all the coordinate mess";
		[DATABASE saveManagedObjectContext];

	}
	
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	FUNCTION_LOG(@"Saving object context");
	[DATABASE saveManagedObjectContext];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
