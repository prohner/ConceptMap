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

- (ConceptObject *)newConceptObject:(NSString *)body titled:(NSString *)title at:(CGPoint)origin sized:(CGSize)size insideOf:(ConceptObject *)containerObject colored:(ColorSchemeConstant)color {
	LOG_POINT(origin);
	//	origin = [conceptMapView.layer convertPoint:origin fromLayer:containerObject.layer];
	//	origin = [self.view.layer convertPoint:origin fromLayer:containerObject.layer];
	LOG_POINT(origin);
	CGRect r = CGRectMake(origin.x, origin.y, size.width, size.height);
	
	Concept *concept = [DATABASE newConceptTitled:title toDocument:conceptMapView.currentDocument];
	[concept setRect:r];
	concept.colorSchemeConstant = [NSNumber numberWithInt:color];
	
	ConceptObject *co = [ConceptObject conceptObjectWithConcept:concept];
	[co setFrame:r];
	[co setBodyDisplayStringText:body];
	//	[self addConceptTemplate:co];
	
	origin = [conceptMapView.layer convertPoint:origin fromLayer:containerObject.layer];
	r = CGRectMake(origin.x, origin.y, size.width, size.height);
	[concept setRect:r];
	
	[containerObject addConceptObject:co];
	return co;
}

- (ConceptObject *)newConceptObjectTitled:(NSString *)title inRect:(CGRect)r {
	Concept *concept = [DATABASE newConceptTitled:NSLocalizedString(title, @"") toDocument:conceptMapView.currentDocument];
	[concept setRect:r];
	concept.colorSchemeConstant = [NSNumber numberWithInt:[Utility nextColorScheme]];
	ConceptObject *co = [ConceptObject conceptObjectWithConcept:concept];
	[co setFrame:r];
	[self addConceptTemplate:co];
	return co;
}

- (IBAction)documentTitleChanged:(id)sender {
	[DATABASE currentDocument].title = documentTitle.text;
}


#pragma mark Add Items 

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
//	theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
//	theAnimation.autoreverses=YES;
//	theAnimation.duration=0.15;
//	theAnimation.repeatCount=2;
//	theAnimation.fromValue=[NSNumber numberWithFloat:20];
//	theAnimation.toValue=[NSNumber numberWithFloat:45];
	theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
	theAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
	theAnimation.toValue = [NSNumber numberWithFloat:1.0f];
	[newConceptObject.layer addAnimation:theAnimation forKey:@"animateLayer"];	
	[conceptMapView addConceptObject:newConceptObject toView:conceptMapView];
}

- (void)addSquare {
	CGRect r = CGRectMake(40, 40, 250, 250);
	[self newConceptObjectTitled:NSLocalizedString(@"New Square", @"") inRect:r];
}

- (void)addVerticalRectangle {
	CGRect r = CGRectMake(40, 40, 200, 300);
	[self newConceptObjectTitled:NSLocalizedString(@"New Rectangle", @"") inRect:r];
}

- (void)addHorizontalRectangle {
	CGRect r = CGRectMake(40, 40, 300, 200);
	[self newConceptObjectTitled:NSLocalizedString(@"New Rectangle", @"") inRect:r];
}

- (void)addHelp {
	CGRect r = CGRectMake(10, 10, 600, 600);
	ConceptObject *template = [self newConceptObjectTitled:NSLocalizedString(@"Help", @"") inRect:r];
	template.concept.bodyDisplayString = @"  ";
	template.concept.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantPurple];

	[self newConceptObject:NSLocalizedString(@"ARRANGING_THOUGHTS", @"") 
					titled:NSLocalizedString(@"Arranging Thoughts", @"")
						at:CGPointMake(15, 25) 
					 sized:CGSizeMake(260, 170) 
				  insideOf:template 
				   colored:ColorSchemeConstantLightBlue];
	
	[self newConceptObject:NSLocalizedString(@"ADDING_THOUGHTS", @"") 
					titled:NSLocalizedString(@"Add / Delete", @"")
						at:CGPointMake(325, 25) 
					 sized:CGSizeMake(260, 170) 
				  insideOf:template 
				   colored:ColorSchemeConstantLightBlue];
	
	[self newConceptObject:NSLocalizedString(@"EDITING_CONTENTS", @"") 
					titled:NSLocalizedString(@"Editing", @"")
						at:CGPointMake(15, 205) 
					 sized:CGSizeMake(570, 120) 
				  insideOf:template 
				   colored:ColorSchemeConstantLightBlue];
	
	[self newConceptObject:NSLocalizedString(@"CHANGING_PROPERTIES", @"") 
					titled:NSLocalizedString(@"Changing Properties", @"")
						at:CGPointMake(15, 335) 
					 sized:CGSizeMake(570, 120) 
				  insideOf:template 
				   colored:ColorSchemeConstantLightBlue];
	
	[self newConceptObject:NSLocalizedString(@"CHANGING_CONNECTIONS", @"") 
					titled:NSLocalizedString(@"Changing Connections", @"")
						at:CGPointMake(15, 465) 
					 sized:CGSizeMake(570, 120) 
				  insideOf:template 
				   colored:ColorSchemeConstantLightBlue];
	
	template.selected = YES;
}

- (void)addComputerServer {
	int originX = 30;
	int originY = 30;
	
	ConceptObject *computerTemplate = [self newConceptObjectTitled:NSLocalizedString(@"Server", @"") inRect:CGRectMake(originX, originY, 300, 350)];
	computerTemplate.concept.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightBrown];
	[computerTemplate setBodyDisplayStringText: NSLocalizedString(@"Power Comp - Windows Server 2008 SP 2", @"")];
	
	ConceptObject *drives = [self newConceptObject:@" "  
											titled:NSLocalizedString(@"Disk Drives", @"")
												at:CGPointMake(90, 90) 
											 sized:CGSizeMake(200, 150) 
										  insideOf:computerTemplate 
										   colored:ColorSchemeConstantBlue];
	
	[self newConceptObject:NSLocalizedString(@"300gb - SATA", @"") 
					titled:NSLocalizedString(@"Internal Drives", @"")
						at:CGPointMake(10, 20) 
					 sized:CGSizeMake(180, 50) 
				  insideOf:drives 
				   colored:ColorSchemeConstantLightGreen];
	
	[self newConceptObject:NSLocalizedString(@"RAID - 3tb", @"")
					titled:NSLocalizedString(@"External Drives", @"")
						at:CGPointMake(10, 80) 
					 sized:CGSizeMake(180, 50) 
				  insideOf:drives 
				   colored:ColorSchemeConstantLightGreen];
	
	[self newConceptObject:NSLocalizedString(@"192.168.1.17\n192.168.12.11", @"")
					titled:NSLocalizedString(@"IP Addresses", @"")
						at:CGPointMake(90, 250) 
					 sized:CGSizeMake(200, 70) 
				  insideOf:computerTemplate 
				   colored:ColorSchemeConstantBlue];
	
	[computerTemplate setNeedsDisplay];
}

- (void)addComputerDesktop {
	int originX = 50;
	int originY = 50;
	
	ConceptObject *computerTemplate = [self newConceptObjectTitled:NSLocalizedString(@"Desktop", @"") inRect:CGRectMake(originX, originY, 300, 280)];
	computerTemplate.concept.colorSchemeConstant = [NSNumber numberWithInt:ColorSchemeConstantLightBlue];
	[computerTemplate setBodyDisplayStringText: NSLocalizedString(@"Model 760 - Windows 7", @"")];
	
	ConceptObject *drives = [self newConceptObject:@" "  
											titled:NSLocalizedString(@"Disk Drives", @"")
												at:CGPointMake(90, 90) 
											 sized:CGSizeMake(200, 80) 
										  insideOf:computerTemplate 
										   colored:ColorSchemeConstantBlue];
	
	[self newConceptObject:NSLocalizedString(@"300gb - SATA", @"") 
					titled:NSLocalizedString(@"Internal Drives", @"")
						at:CGPointMake(10, 20) 
					 sized:CGSizeMake(180, 50) 
				  insideOf:drives 
				   colored:ColorSchemeConstantLightGreen];
	
	[self newConceptObject:NSLocalizedString(@"192.168.1.17", @"")
					titled:NSLocalizedString(@"IP Addresses", @"")
						at:CGPointMake(90, 200) 
					 sized:CGSizeMake(200, 70) 
				  insideOf:computerTemplate 
				   colored:ColorSchemeConstantBlue];
	
	[computerTemplate setNeedsDisplay];
}

- (void)addComputerSwitch {
	int originX = 60;
	int originY = 60;
	
	ConceptObject *template = [self newConceptObjectTitled:NSLocalizedString(@"Switch", @"") inRect:CGRectMake(originX, originY, 300, 280)];
	template.concept.colorSchemeConstant = [NSNumber numberWithInt:[Utility nextColorScheme]];
	[template setBodyDisplayStringText: NSLocalizedString(@"", @"")];
}

- (void)addComputerRouter {
	int originX = 70;
	int originY = 70;
	
	ConceptObject *template = [self newConceptObjectTitled:NSLocalizedString(@"Router", @"") inRect:CGRectMake(originX, originY, 300, 280)];
	template.concept.colorSchemeConstant = [NSNumber numberWithInt:[Utility nextColorScheme]];
	[template setBodyDisplayStringText: NSLocalizedString(@"", @"")];
}

- (void)addComputerFirewall {
	int originX = 80;
	int originY = 80;
	
	ConceptObject *template = [self newConceptObjectTitled:NSLocalizedString(@"Firewall", @"") inRect:CGRectMake(originX, originY, 300, 280)];
	template.concept.colorSchemeConstant = [NSNumber numberWithInt:[Utility nextColorScheme]];
	[template setBodyDisplayStringText: NSLocalizedString(@"", @"")];
}

- (void)addComputerConcentrator {
	int originX = 90;
	int originY = 90;
	
	ConceptObject *template = [self newConceptObjectTitled:NSLocalizedString(@"Concentrator", @"") inRect:CGRectMake(originX, originY, 300, 280)];
	template.concept.colorSchemeConstant = [NSNumber numberWithInt:[Utility nextColorScheme]];
	[template setBodyDisplayStringText: NSLocalizedString(@"", @"")];
}

- (void)addComputerRack {
	int originX = 100;
	int originY = 100;
	
	ConceptObject *template = [self newConceptObjectTitled:NSLocalizedString(@"Rack", @"") inRect:CGRectMake(originX, originY, 200, 300)];
	template.concept.colorSchemeConstant = [NSNumber numberWithInt:[Utility nextColorScheme]];
	[template setBodyDisplayStringText: NSLocalizedString(@"", @"")];

	[self newConceptObject:NSLocalizedString(@"Purpose 1", @"")
					titled:NSLocalizedString(@"Computer 1", @"")
						at:CGPointMake(20, 30) 
					 sized:CGSizeMake(160, 70) 
				  insideOf:template 
				   colored:ColorSchemeConstantBlue];
	
	[self newConceptObject:NSLocalizedString(@"Purpose 2", @"")
					titled:NSLocalizedString(@"Computer 2", @"")
						at:CGPointMake(20, 110) 
					 sized:CGSizeMake(160, 70) 
				  insideOf:template 
				   colored:ColorSchemeConstantBlue];

	[self newConceptObject:NSLocalizedString(@"Purpose 3", @"")
					titled:NSLocalizedString(@"Computer 3", @"")
						at:CGPointMake(20, 190) 
					 sized:CGSizeMake(160, 70) 
				  insideOf:template 
				   colored:ColorSchemeConstantBlue];
}

- (void)addHomeGarage {
	int originX = 110;
	int originY = 110;
	
	ConceptObject *template = [self newConceptObjectTitled:NSLocalizedString(@"Garage Cabinet", @"") inRect:CGRectMake(originX, originY, 200, 400)];
	template.concept.colorSchemeConstant = [NSNumber numberWithInt:[Utility nextColorScheme]];
	[template setBodyDisplayStringText: NSLocalizedString(@"Stuff stored in cabinet", @"")];
}


- (void)addHomeCloset {
	int originX = 120;
	int originY = 120;
	
	ConceptObject *template = [self newConceptObjectTitled:NSLocalizedString(@"Closet", @"") inRect:CGRectMake(originX, originY, 300, 500)];
	template.concept.colorSchemeConstant = [NSNumber numberWithInt:[Utility nextColorScheme]];
	[template setBodyDisplayStringText: NSLocalizedString(@"", @"")];

	[self newConceptObject:@" "
					titled:NSLocalizedString(@"Upper Shelf", @"")
						at:CGPointMake(20, 30) 
					 sized:CGSizeMake(260, 150) 
				  insideOf:template 
				   colored:ColorSchemeConstantBlue];
	
	[self newConceptObject:@" "
					titled:NSLocalizedString(@"Closet Floor", @"")
						at:CGPointMake(20, 200) 
					 sized:CGSizeMake(260, 200) 
				  insideOf:template 
				   colored:ColorSchemeConstantBlue];
}

#pragma mark Slider Updates
- (IBAction)sliderStarted:(id)sender {
	conceptMapViewDelegateHold = conceptMapView.delegate;

	FUNCTION_LOG(@"min=%.2f, max=%.2f", conceptMapView.minimumZoomScale, conceptMapView.maximumZoomScale);
	[conceptMapView setMinimumZoomScale:1.00f];
	[conceptMapView setMaximumZoomScale:3.00f];
//	[conceptMapView setZoomScale:1.0f];
	conceptMapView.delegate = self;
}

- (IBAction)sliderChanged:(id)sender {
	UISlider *slider = (UISlider *)sender;
	[conceptMapView setZoomScale:slider.value];
	FUNCTION_LOG(@"zoom scale: %.2f", slider.value);
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
