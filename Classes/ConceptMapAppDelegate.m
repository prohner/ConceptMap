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
#import "Concept.h"
#import "UIApplication+ScreenMirroring.h"

@implementation ConceptMapAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch. 
	if ([[DATABASE documents] count] <= 0) {
		[self createHomeInventoryDocument];
		[self createWelcomeDocument];
	}

	[[UIApplication sharedApplication] setupScreenMirroringWithFramesPerSecond:20.0];
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

	return YES;
}

- (void)createWelcomeDocument {
	Document *doc;
	Concept *concept;
	Concept *drives;
	Concept *edrives;
	Concept *idrives;
	Concept *ips;
	UIImage *image;

	doc = [DATABASE newDocumentTitled:NSLocalizedString(@"Welcome Document", @"")];
	image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"desktop_2" ofType:@"jpg"]];
	doc.desktopImage = UIImageJPEGRepresentation(image, 1.0);
	
	concept = [DATABASE newConceptTitled:NSLocalizedString(@"Computer Template", @"") toDocument:doc];
	concept.originX = [NSNumber numberWithInt:170];
	concept.originY = [NSNumber numberWithInt:330];
	concept.height = [NSNumber numberWithInt: 300];
	concept.width = [NSNumber numberWithInt: 350];
	concept.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightBrown];
	concept.bodyDisplayString = NSLocalizedString(@"Power Comp - Windows Server 2008 SP 2", @"");
	
	drives = [DATABASE newConceptTitled:NSLocalizedString(@"Disk Drives", @"") toDocument:doc];
	drives.originX = [NSNumber numberWithInt: 295];
	drives.originY = [NSNumber numberWithInt: 390];
	drives.height = [NSNumber numberWithInt:150];
	drives.width = [NSNumber numberWithInt:200];
	drives.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantBlue];
	drives.bodyDisplayString = @" ";
	[concept addConcept:drives];
	
	idrives = [DATABASE newConceptTitled:NSLocalizedString(@"Internal Drives", @"") toDocument:doc];
	idrives.originX = [NSNumber numberWithInt: 305];
	idrives.originY = [NSNumber numberWithInt: 410];
	idrives.height = [NSNumber numberWithInt:50];
	idrives.width = [NSNumber numberWithInt:180];
	idrives.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightGreen];
	idrives.bodyDisplayString = NSLocalizedString(@"300gb - SATA", @"");
	[drives addConcept:idrives];
	
	edrives = [DATABASE newConceptTitled:NSLocalizedString(@"External Drives", @"") toDocument:doc];
	edrives.originX = [NSNumber numberWithInt: 305];
	edrives.originY = [NSNumber numberWithInt: 475];
	edrives.height = [NSNumber numberWithInt:50];
	edrives.width = [NSNumber numberWithInt:180];
	edrives.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightGreen];
	edrives.bodyDisplayString = NSLocalizedString(@"RAID - 3tb", @"");
	[drives addConcept:edrives];
	
	ips = [DATABASE newConceptTitled:NSLocalizedString(@"IP Addresses", @"") toDocument:doc];
	ips.originX = [NSNumber numberWithInt: 295];
	ips.originY = [NSNumber numberWithInt: 550];
	ips.height = [NSNumber numberWithInt:70];
	ips.width = [NSNumber numberWithInt:200];
	ips.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantBlue];
	ips.bodyDisplayString = NSLocalizedString(@"192.168.1.17\n192.168.12.11", @"");
	[concept addConcept:ips];
	
	concept = [DATABASE newConceptTitled:NSLocalizedString(@"Welcome to Concept Map", @"") toDocument:doc];
	concept.originX = [NSNumber numberWithInt:380];
	concept.originY = [NSNumber numberWithInt: 50];
	concept.height = [NSNumber numberWithInt: 220];
	concept.width = [NSNumber numberWithInt: 300];
	concept.fontSize = [NSNumber numberWithInt:14];
	concept.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightBlue];
	concept.bodyDisplayString = NSLocalizedString(@"Some tips:\n- Tap an object to highlight then use the 'info' button or delete button\n- Tap and move an object\n- Use the 'pinch' gesture to resize an object\n\nTo Do:\nConnect objects\nCleanup all the coordinate mess", @"");
	
	[DATABASE currentDocument].desktopImage = UIImageJPEGRepresentation(image, 1.0);
	[DATABASE saveManagedObjectContext];
}

- (void)createHomeInventoryDocument {
	Document *doc;
	Concept *concept;
	Concept *cabLeft;
	Concept *cabRight;
	Concept *c;
	Concept *c2;
	UIImage *image;

	doc = [DATABASE newDocumentTitled:NSLocalizedString(@"Home Inventory", @"")];
	image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"desktop_1" ofType:@"jpg"]];
	doc.desktopImage = UIImageJPEGRepresentation(image, 1.0);
	
	concept = [DATABASE newConceptTitled:NSLocalizedString(@"Garage", @"") 
							  toDocument:doc 
								withRect:CGRectMake(100, 50, 425, 425)];
	concept.bodyDisplayString = @" ";
	concept.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightGreen];

	cabLeft = [DATABASE newConceptTitled:NSLocalizedString(@"Left Cabinet", @"") 
							  toDocument:doc 
								withRect:CGRectMake(110, 130, 200, 200)];
	cabLeft.bodyDisplayString = @" ";
	cabLeft.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantBlue];
	[concept addConcept:cabLeft];
	
	c = [DATABASE newConceptTitled:NSLocalizedString(@"Soccer ball", @"") 
						toDocument:doc 
						  withRect:CGRectMake(120, 150, 110, 25)];
	c.bodyDisplayString = @" ";
	c.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightBlue];
	[cabLeft addConcept:c];
	
	c = [DATABASE newConceptTitled:NSLocalizedString(@"Green Duffle", @"") 
						toDocument:doc 
						  withRect:CGRectMake(120, 185, 180, 100)];
	c.bodyDisplayString = @" ";
	c.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightGreen];
	[cabLeft addConcept:c];
	
	c2 = [DATABASE newConceptTitled:NSLocalizedString(@"Medicine Kit", @"") 
						 toDocument:doc 
						   withRect:CGRectMake(130, 205, 120, 55)];
	c2.bodyDisplayString = NSLocalizedString(@"Bandages\nGauze\nTape", @"");
	c2.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightBrown];
	[c addConcept:c2];
	
	cabRight = [DATABASE newConceptTitled:NSLocalizedString(@"Right Cabinet", @"") 
							   toDocument:doc 
								 withRect:CGRectMake(315, 130, 200, 200)];
	cabRight.bodyDisplayString = @" ";
	cabRight.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantBlue];
	[concept addConcept:cabRight];

	concept = [DATABASE newConceptTitled:NSLocalizedString(@"Hall Closet", @"") 
							  toDocument:doc
								withRect:CGRectMake(75, 550, 525, 350)];
	concept.bodyDisplayString = @" ";
	concept.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightBlue];
	
	c = [DATABASE newConceptTitled:NSLocalizedString(@"Board Games", @"") 
						toDocument:doc
						  withRect:CGRectMake(85, 625, 180, 100)];
	c.bodyDisplayString = NSLocalizedString(@"All of them", @"");
	c.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantGreen];
	[concept addConcept:c];
	
	c = [DATABASE newConceptTitled:NSLocalizedString(@"iPhone Box", @"") 
						toDocument:doc
						  withRect:CGRectMake(295, 625, 110, 25)];
	c.bodyDisplayString = @" ";
	c.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantGreen];
	[concept addConcept:c];
	

	[DATABASE saveManagedObjectContext];
	
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

#ifdef DEBUG
	for (Concept *concept in [[DATABASE currentDocument].concepts allObjects]) {
		FUNCTION_LOG(@"Connecting %@ to ....", concept.title);
		for (ConnectedConcept *connectedConcept in [[concept connectedConcepts] allObjects]) {
			FUNCTION_LOG(@"\t\t %@.", connectedConcept.objectURL);
		}
	}
#endif
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
