//
//  ActionsViewController.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/29/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ActionsViewController.h"
#import "Utility.h"
#import "DataController.h"
#import "ConceptObject.h"
#import "ConceptMapView.h"

#define ROW_EMAIL_AS_IMAGE		0
#define ROW_EMAIL_AS_LIST		1
#define ROW_EMAIL_AS_COMBO		2

@implementation ActionsViewController

@synthesize conceptMapView;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = NSLocalizedString(@"Actions", @"");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 132.0);
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	switch (indexPath.row) {
		case ROW_EMAIL_AS_IMAGE:
			cell.textLabel.text = NSLocalizedString(@"Email as Image", @"");
			break;
		case ROW_EMAIL_AS_LIST:
			cell.textLabel.text = NSLocalizedString(@"Email as List", @"");
			break;
		case ROW_EMAIL_AS_COMBO:
			cell.textLabel.text = NSLocalizedString(@"Email as List + Image", @"");
			break;
		default:
			break;
	}
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	switch (indexPath.row) {
		case ROW_EMAIL_AS_IMAGE:
			[self sendEmailIncludingImage:YES andList:NO];
			break;
		case ROW_EMAIL_AS_LIST:
			[self sendEmailIncludingImage:NO andList:YES];
			break;
		case ROW_EMAIL_AS_COMBO:
			[self sendEmailIncludingImage:YES andList:YES];
			break;
		default:
			break;
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.conceptMapView = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark Email Methods

- (void)sendEmailIncludingImage:(BOOL)includeImage andList:(BOOL)includeList {
	MFMailComposeViewController* composerController = [[MFMailComposeViewController alloc] init];
	composerController.mailComposeDelegate = self;
	NSString *subject = [[NSString alloc] initWithFormat:@"%@", [DATABASE currentDocument].title];
	NSString *messageBody = [self conceptMapAsList];
	NSString *body = [[NSString alloc] initWithFormat:@"<div></div>"
					  "<div style=\"\">%@: </div>"
					  "<div>%@</div>"
					  "<div><p>%@ "
					  "<span style=\"background-color:#ffff00\"><a href=\"http://cooltoolapps.appspot.com/what-in-the-world-learn\">%@</a></span>"
					  " %@ %@.</p></div>", 
					  APPLICATION_NAME,
					  (includeList ? messageBody : @""),
					  NSLocalizedString(@"Created using", @""),
					  APPLICATION_NAME,
					  NSLocalizedString(@"on my", @""),
					  [[UIDevice currentDevice] model]];
	[composerController setSubject:subject];
	
	if (includeImage) {
		[composerController addAttachmentData:UIImagePNGRepresentation([conceptMapView conceptMapAsImage]) mimeType:@"image/png" fileName:@"Map.png"];
	}
	
	[composerController setMessageBody:body isHTML:YES]; 
	[self presentModalViewController:composerController animated:YES];
	[composerController release];
	[subject release];
	FUNCTION_LOG(@"%@", body);
	[body release];
}

- (NSString *)conceptMapAsList {
	//	NSLog(@"Need to send email");
	NSMutableString *messageBody = [[NSMutableString alloc] initWithString:@"<dl>"];
	for (Concept *concept in [DATABASE currentDocument].concepts) {
		if (concept.parentConcept == nil) {
			[messageBody appendFormat:@"<div style=\"margin-left:5px;margin-top:5px;%@\">\n", [self borderInfoWithColor:concept.conceptObjectColorSet]];
			[messageBody appendString:[self stringForConcept:concept withIndent:@""]];
			[messageBody appendString:[self concepts:concept.concepts indented:@"&nbsp;"]];
			[messageBody appendString:@"</div>\n"];
		}
	}

	[messageBody appendString:@"</dl>"];
	return messageBody;
}

- (NSString *)concepts:(NSSet *)concepts indented:(NSString *)indent {
	NSMutableString *s = [[NSMutableString alloc] init];
	NSString *nextIndent = [[NSString alloc] initWithFormat:@"%@&nbsp;", indent];
	NSArray *listItems = [nextIndent componentsSeparatedByString:@"&"];
	int indentations = [listItems count];
	
	for (Concept *concept in concepts) {
		[s appendFormat:@"<div style=\"margin-left:%ipx;%@\">\n", (indentations * 5), [self borderInfoWithColor:concept.conceptObjectColorSet]];
		[s appendString:[self stringForConcept:concept withIndent:indent]];
		[s appendString:[self concepts:concept.concepts indented:nextIndent]];
		[s appendString:@"</div>\n"];
	}
	[nextIndent release];
	return s;
}

- (NSString *)borderInfoWithColor:(ConceptObjectColorSet *)conceptObjectColorSet {
	return [[NSString alloc] initWithFormat:@"xborder-top-color:#%@;border-left-color:#%@;border-top-style:none;border-left-style:solid;border-width:medium;", 
			[ConceptObjectColorSet colorToHexString:conceptObjectColorSet.backgroundColor],
			[ConceptObjectColorSet colorToHexString:conceptObjectColorSet.backgroundColor]];
	
}

- (NSString *)stringForConcept:(Concept *)concept withIndent:(NSString *)indent {
	return [[NSString alloc] initWithFormat:@"<dt style=\"font-weight:bold;\">%@</dt><dd>%@</dd>\n", concept.title, [concept.bodyDisplayString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"]];
	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}


@end

