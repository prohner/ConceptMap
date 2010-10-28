//
//  ConceptMapViewController.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright Cool Tool Apps 2010. All rights reserved.
//

#import "ConceptMapViewController.h"
#import "ActionsViewController.h"
#import "DocumentSettingsViewController.h"
#import "AddConceptObjectViewController.h"


@implementation ConceptMapViewController

@synthesize toolbar, documentsButton, documentTitle, documentTitleHolder, popover;
@synthesize propertyInspectorButton, conceptMapView;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	CGRect frame = CGRectMake(0, 0, 200, 30);
	self.documentTitle = [[UITextField alloc] initWithFrame:frame];
	documentTitle.borderStyle = UITextBorderStyleRoundedRect;
	documentTitle.textColor = [UIColor blackColor];
	documentTitle.font = [UIFont systemFontOfSize:17.0];
	documentTitle.placeholder = NSLocalizedString(@"<Enter Document Title>", @"");
	documentTitle.backgroundColor = [UIColor blackColor];
	//documentTitle.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	documentTitle.autocapitalizationType = UITextAutocapitalizationTypeWords;
	documentTitle.keyboardType = UIKeyboardTypeDefault;
	documentTitle.returnKeyType = UIReturnKeyDone;
	documentTitle.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
//	documentTitleHolder.customView = documentTitle;
	[documentTitle addTarget:self action:@selector(documentTitleChanged:) forControlEvents:UIControlEventEditingChanged];

	NSMutableArray *items = [toolbar.items mutableCopy];
	int titleIndex = [items indexOfObject:documentTitleHolder];

	documentTitleHolder = [[UIBarButtonItem alloc] initWithCustomView:documentTitle];
	[items replaceObjectAtIndex:titleIndex withObject:documentTitleHolder];
	toolbar.items = items;
	[documentTitleHolder release];
	
	[documentsButton setTitle:NSLocalizedString(@"Documents", @"")];
	[propertyInspectorButton setTitle:NSLocalizedString(@"Desktop", @"")];
	
	[self resetConceptMapView];
}

- (void)resetConceptMapView {
	if (0 && conceptMapView) {
		[conceptMapView removeFromSuperview];
		[conceptMapView release];
		conceptMapView = nil;
	}
	
	documentTitle.text = [DATABASE currentDocument].title;
    CGRect viewFrame = self.view.frame;
    viewFrame.origin = CGPointMake(0, toolbar.bounds.size.height);
    conceptMapView = [[ConceptMapView alloc] initWithFrame:viewFrame];
	
	conceptMapView.backgroundColor = [UIColor redColor];
	[conceptMapView initializeContents];
	
	[self.view addSubview:conceptMapView];
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	FUNCTION_LOG();
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	FUNCTION_LOG();
	//	if (popoverController) {
	//		CGPoint point = [mapView convertCoordinate:[selectedAnnotation coordinate] toPointToView:mapView];
	//		[popoverController presentPopoverFromRect:CGRectMake(point.x - 30, point.y - 34, 60, 40) inView:mapView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	//	}
	[conceptMapView rotated];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.documentTitle = nil;
	self.popover = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction)documentButtonTapped:(id)sender {
	FUNCTION_LOG();
	
	UIImage *viewImage = [conceptMapView conceptMapAsImage];
	conceptMapView.currentDocument.image = UIImageJPEGRepresentation(viewImage, 1.0);
	
	DocumentsViewController *documentsViewController = [[[DocumentsViewController alloc] initWithNibName:@"DocumentsViewController" bundle:nil] retain];
	documentsViewController.conceptMapViewController = self;
	
	UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:documentsViewController];
	[documentsViewController release];
	
	self.popover = [self popoverControllerFor:navCtrl];
	[popover presentPopoverFromBarButtonItem:documentsButton 
					permittedArrowDirections:UIPopoverArrowDirectionAny 
									animated:YES];
	[navCtrl release];
}

- (IBAction)actionButtonTapped:(id)sender {
	ActionsViewController *actionsViewController = [[ActionsViewController alloc] initWithNibName:@"ActionsViewController" bundle:nil];
	actionsViewController.conceptMapView = conceptMapView;
	UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:actionsViewController];
	[actionsViewController release];
	
	self.popover = [self popoverControllerFor:navCtrl];
	[popover presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender 
					permittedArrowDirections:UIPopoverArrowDirectionAny 
									animated:YES];
	[navCtrl release];
}

- (IBAction)settingsButtonTapped:(id)sender {
	DocumentSettingsViewController *documentSettingsViewController = [[DocumentSettingsViewController alloc] initWithNibName:@"DocumentSettingsViewController" bundle:nil];
	UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:documentSettingsViewController];
	documentSettingsViewController.conceptMapViewController = self;
	
	[documentSettingsViewController release];
	
	self.popover = [self popoverControllerFor:navCtrl];
	[popover presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender 
					permittedArrowDirections:UIPopoverArrowDirectionAny 
									animated:YES];
	[navCtrl release];
}

- (UIPopoverController *)popoverControllerFor:(UIViewController *)vc {
	[self.popover dismissPopoverAnimated:YES];
	return [[UIPopoverController alloc] initWithContentViewController:vc];
	
}

- (IBAction)addButtonTapped:(id)sender {
	AddConceptObjectViewController *ctrl = [[AddConceptObjectViewController alloc] initWithNibName:@"AddConceptObjectViewController" bundle:nil];	
	ctrl.conceptMapViewController = self;
	self.popover = [self popoverControllerFor:ctrl];
	[popover presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender 
					permittedArrowDirections:UIPopoverArrowDirectionAny 
									animated:YES];
	[ctrl release];
}

- (IBAction)addConcept:(id)sender {
	FUNCTION_LOG(@"View=(%i), Doc=(%i)", conceptMapView, conceptMapView.currentDocument);

	CGRect r = CGRectMake(40, 40, 200, 200);
	Concept *concept = [DATABASE newConceptTitled:@"New Item" 
									   toDocument:conceptMapView.currentDocument];
	[concept setRect:r];
	ConceptObject *co = [ConceptObject conceptObjectWithConcept:concept];
	[co setFrame:r];
	co.backgroundColor = [UIColor darkGrayColor];
	
	
	CABasicAnimation *theAnimation;	
	theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
	theAnimation.duration=0.15;
	theAnimation.repeatCount=2;
	theAnimation.autoreverses=YES;
	theAnimation.fromValue=[NSNumber numberWithFloat:20];
	theAnimation.toValue=[NSNumber numberWithFloat:45];
	[co.layer addAnimation:theAnimation forKey:@"animateLayer"];	
	[conceptMapView addConceptObject:co toView:conceptMapView];
}

- (void)addConceptTemplate:(ConceptObject *)newConceptObject {
	CABasicAnimation *theAnimation;	
	theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
	theAnimation.duration=0.15;
	theAnimation.repeatCount=2;
	theAnimation.autoreverses=YES;
	theAnimation.fromValue=[NSNumber numberWithFloat:20];
	theAnimation.toValue=[NSNumber numberWithFloat:45];
	[newConceptObject.layer addAnimation:theAnimation forKey:@"animateLayer"];	
	[conceptMapView addConceptObject:newConceptObject toView:conceptMapView];
}

- (void)addSquare {
	CGRect r = CGRectMake(40, 40, 250, 250);
	[self newConceptObjectTitled:@"New Square" inRect:r];
}

- (void)addVerticalRectangle {
	CGRect r = CGRectMake(40, 40, 200, 300);
	[self newConceptObjectTitled:@"New Rectangle" inRect:r];
}

- (void)addHorizontalRectangle {
	CGRect r = CGRectMake(40, 40, 300, 200);
	[self newConceptObjectTitled:@"New Rectangle" inRect:r];
}

- (void)addComputerServer {
	int originX = 30;
	int originY = 30;
	
	ConceptObject *computerTemplate = [self newConceptObjectTitled:NSLocalizedString(@"Computer Template", @"") inRect:CGRectMake(originX, originY, 300, 350)];
	computerTemplate.concept.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightBrown];
	[computerTemplate setBodyDisplayStringText: NSLocalizedString(@"Power Comp - Windows Server 2008 SP 2", @"")];
	
//	ConceptObject *drives = //[self newConceptObjectTitled:NSLocalizedString(@"Disk Drives", @"") inRect:CGRectMake(originX + 55, originY + 60, 200, 150)];
//							[self newConceptObject:@" " titled:(NSString *)title at:CGPointMake(originX + 55, originY + 60) sized:CGSizeMake(200, 150) insideOf:computerTemplate];
//	drives.concept.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantBlue];
//	[drives setBodyDisplayStringText: NSLocalizedString(@" ", @"")];

	ConceptObject *drives = [self newConceptObject:@" " 
											titled:NSLocalizedString(@"Disk Drives", @"")
												at:CGPointMake(55, 60) 
											 sized:CGSizeMake(200, 150) 
										  insideOf:computerTemplate 
										   colored:ColorSchemeConstantBlue];

	
//	ConceptObject *idrives = [self newConceptObjectTitled:NSLocalizedString(@"Internal Drives", @"") inRect:CGRectMake(originX + 135, originY + 70, 180, 50)];
//	idrives.concept.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightGreen];
//	idrives.concept.bodyDisplayString = NSLocalizedString(@"300gb - SATA", @"");
//	[drives addConceptObject:idrives];
//
//	ConceptObject *edrives = [self newConceptObjectTitled:NSLocalizedString(@"External Drives", @"") inRect:CGRectMake(originX + 135, originY + 145, 180, 50)];
//	edrives.concept.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightGreen];
//	edrives.concept.bodyDisplayString = NSLocalizedString(@"RAID - 3tb", @"");
//	[drives addConceptObject:edrives];
//	
//	ConceptObject *ips = [self newConceptObjectTitled:NSLocalizedString(@"IP Addresses", @"") inRect:CGRectMake(originX + 125, originY + 220, 200, 70)];
//	ips.concept.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantBlue];
//	ips.concept.bodyDisplayString = NSLocalizedString(@"192.168.1.17\n192.168.12.11", @"");
//	[computerTemplate addConceptObject:ips];
	
	[computerTemplate setNeedsDisplay];
	[drives setNeedsDisplay];
}

- (ConceptObject *)newConceptObject:(NSString *)body titled:(NSString *)title at:(CGPoint)origin sized:(CGSize)size insideOf:(ConceptObject *)containerObject colored:(ColorSchemeConstant)color {
	LOG_POINT(origin);
	origin = [conceptMapView.layer convertPoint:origin toLayer:containerObject.layer];
	LOG_POINT(origin);
	CGRect r = CGRectMake(origin.x, origin.y, size.width, size.height);
	
	Concept *concept = [DATABASE newConceptTitled:title toDocument:conceptMapView.currentDocument];
	[concept setRect:r];
	concept.colorSchemeConstant = [NSNumber numberWithInt:color];;

	ConceptObject *co = [ConceptObject conceptObjectWithConcept:concept];
	[co setFrame:r];
	[co setBodyDisplayStringText:body];
//	[self addConceptTemplate:co];
	
	[containerObject addConceptObject:co];
	return co;
}

- (ConceptObject *)newConceptObjectTitled:(NSString *)title inRect:(CGRect)r {
	Concept *concept = [DATABASE newConceptTitled:NSLocalizedString(title, @"") toDocument:conceptMapView.currentDocument];
	[concept setRect:r];
	ConceptObject *co = [ConceptObject conceptObjectWithConcept:concept];
	[co setFrame:r];
	[self addConceptTemplate:co];
	return co;
}

- (IBAction)documentTitleChanged:(id)sender {
	[DATABASE currentDocument].title = documentTitle.text;
}

- (IBAction)sliderStarted:(id)sender {
	conceptMapViewDelegateHold = conceptMapView.delegate;

	FUNCTION_LOG(@"min=%.2f, max=%.2f", conceptMapView.minimumZoomScale, conceptMapView.maximumZoomScale);
	[conceptMapView setMinimumZoomScale:1.00f];
	[conceptMapView setMaximumZoomScale:5.00f];
//	[conceptMapView setZoomScale:1.0f];
	conceptMapView.delegate = self;
}

- (IBAction)sliderChanged:(id)sender {
	UISlider *slider = (UISlider *)sender;
	[conceptMapView setZoomScale:slider.value];
	FUNCTION_LOG(@"zomm scale: %.2f", slider.value);
	[conceptMapView setNeedsDisplay];
}

- (IBAction)sliderStopped:(id)sender {
	FUNCTION_LOG(@"scale=%.2f, width=%.2f, height=%.2f", conceptMapView.zoomScale, conceptMapView.contentSize.width, conceptMapView.contentSize.height);
	conceptMapView.delegate = conceptMapViewDelegateHold;
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	FUNCTION_LOG(@"width=%.2f, height=%.2f", conceptMapView.contentSize.width, conceptMapView.contentSize.height);
	return conceptMapView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	FUNCTION_LOG(@"scale=%.2f, width=%.2f, height=%.2f", conceptMapView.zoomScale, conceptMapView.contentSize.width, conceptMapView.contentSize.height);
	
}


@end
