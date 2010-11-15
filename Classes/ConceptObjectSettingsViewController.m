//
//  ConceptObjectSettingsViewController.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/22/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObjectSettingsViewController.h"
#import "ConceptObjectColorChooserViewController.h"
#import "ConceptObject.h"
#import "ConceptObjectFontChooserViewController.h"
#import "ConceptObjectShapeChooserViewController.h"
#import "ConceptObjectConnectionsViewController.h"

@implementation ConceptObjectSettingsViewController

@synthesize conceptObject, popover, conceptObjectConnections;

#define ROW_COLOR		0
#define ROW_FONT		1
#define ROW_CONNECTIONS	2
#define ROW_SHAPE		3
#define ROW_PICTURE		4

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = NSLocalizedString(@"Settings", @"");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.contentSizeForViewInPopover = CGSizeMake(245.0, 225.0);
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
    return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
	switch (indexPath.row) {
		case ROW_COLOR:
			cell.textLabel.text = NSLocalizedString(@"Colors", @"");
			break;
		case ROW_FONT:
			cell.textLabel.text = NSLocalizedString(@"Fonts", @"");
			break;
		case ROW_CONNECTIONS:
			cell.textLabel.text = NSLocalizedString(@"Connections", @"");
			break;
		case ROW_SHAPE:
			cell.textLabel.text = NSLocalizedString(@"Shapes", @"");
			break;
		case ROW_PICTURE:
			cell.textLabel.text = NSLocalizedString(@"Background Picture", @"");
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
	FUNCTION_LOG();
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	switch (indexPath.row) {
		case ROW_COLOR:
		{
			FUNCTION_LOG(@"At row the row 0 %i", indexPath.row);
			ConceptObjectColorChooserViewController *ctrl = [[ConceptObjectColorChooserViewController alloc] initWithNibName:@"ConceptObjectColorChooserViewController" bundle:nil];
			ctrl.conceptObject = conceptObject;
			[self.navigationController pushViewController:ctrl animated:YES];
			[ctrl release];
		}
			break;
		case ROW_FONT:
		{
			FUNCTION_LOG(@"At row the row 0 %i", indexPath.row);
			ConceptObjectFontChooserViewController *ctrl = [[ConceptObjectFontChooserViewController alloc] initWithNibName:@"ConceptObjectFontChooserViewController" bundle:nil];
			ctrl.conceptObject = conceptObject;
			[self.navigationController pushViewController:ctrl animated:YES];
			[ctrl release];
		}
			break;
		case ROW_SHAPE:
		{
			FUNCTION_LOG(@"At row the row 0 %i", indexPath.row);
			ConceptObjectShapeChooserViewController *ctrl = [[ConceptObjectShapeChooserViewController alloc] initWithNibName:@"ConceptObjectShapeChooserViewController" bundle:nil];
			ctrl.conceptObject = conceptObject;
			[self.navigationController pushViewController:ctrl animated:YES];
			[ctrl release];
		}
			break;
		case ROW_CONNECTIONS:
		{
			FUNCTION_LOG(@"At row the row 0 %i", indexPath.row);
			ConceptObjectConnectionsViewController *ctrl = [[ConceptObjectConnectionsViewController alloc] initWithNibName:@"ConceptObjectConnectionsViewController" bundle:nil];
			ctrl.conceptObject = conceptObject;
			ctrl.popover = popover;
			ctrl.conceptObjectConnections = conceptObjectConnections;
			[self.navigationController pushViewController:ctrl animated:YES];
			[ctrl release];
		}
			break;
		case ROW_PICTURE:
			[self chooseBackgroundImage];
			break;
		default:
			FUNCTION_LOG(@"At row %i", indexPath.row);
			break;
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	FUNCTION_LOG();
	return indexPath;
}

#pragma mark -
#pragma mark Image management
- (void)chooseBackgroundImage {
	UIImagePickerController* picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
	
	[popover setContentViewController:picker animated:YES];
//	[picker release];
	self.title = @"";
	[self retain];	// gotta keep myself around long enough for delegate actions to execute
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	FUNCTION_LOG();
	UIImage *image = ((UIImage *)[info valueForKey:UIImagePickerControllerEditedImage]);
	if (!image) {
		image = ((UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage]);
	}
	conceptObject.layer.contents = (id)image.CGImage;
	conceptObject.concept.backgroundImage = UIImageJPEGRepresentation(image, 1.0);
	
    // Remove the picker interface and release the picker object.
//    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
//    [picker release];
	[popover dismissPopoverAnimated:YES];
	[self release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	FUNCTION_LOG();
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
    [picker release];
	[popover dismissPopoverAnimated:YES];
	[self release];
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
	self.conceptObject = nil;
	self.popover = nil;
	self.conceptObjectConnections = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

