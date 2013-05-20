//
//  third.m
//  DescriptiveCamera
//
//  Created by Siqi Li on 4/3/13.
//  Copyright (c) 2013 Siqi Li. All rights reserved.
//
#import "AppDelegate.h"
#import "third.h"
#import "Cell.h" 
#import "CellView.h"
#import "second.h"

@interface third ()
@end

@implementation third
@synthesize desArray,checkArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //[tableData addObjectsFromArray:viewControllerDelegate.imageArray];
    //tableData = [NSArray arrayWithObjects:@"camera.png", @"photo.png", nil];
    
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.imageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
        static NSString *simpleTableIdentifier = @"Cell";
        
        Cell *cell = (Cell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        //cell.nameLabel.text = [tableData objectAtIndex:indexPath.row];
    
        //cell.cross.image = [UIImage imageNamed:@"cross.png"]  ;
        cell.cross.image =[checkArray objectAtIndex:indexPath.row];
        cell.thumbnailImageView.image = [appDelegate.imageArray objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        //cell.prepTimeLabel.text = [prepTime objectAtIndex:indexPath.row];
        
        return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"disclosure button %d touched",indexPath.row);
    CellView* cellView = [[CellView alloc] initWithNibName:@"CellView" bundle:nil];
    cellView.desArray = desArray;
    cellView.index = indexPath.row;
    [self.navigationController pushViewController:cellView animated:YES];
    //second* secondView = [[second alloc] initWithNibName:@"second" bundle:nil];
    //[self.navigationController pushViewController:secondView animated:YES];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Index Path Raw# = %i", indexPath.row);
    CellView* cellView = [[CellView alloc] initWithNibName:@"CellView" bundle:nil];
    cellView.desArray = desArray;
    cellView.index = indexPath.row;
    [self.navigationController pushViewController:cellView animated:YES];
    //second* secondView = [[second alloc] initWithNibName:@"second" bundle:nil];
    //[self.navigationController pushViewController:secondView animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.imageArray removeObjectAtIndex:indexPath.row];
    [checkArray removeObjectAtIndex:indexPath.row];
    [desArray removeObjectAtIndex:indexPath.row];
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *imageName = [appDelegate.imageNameArray objectAtIndex:indexPath.row];
    [appDelegate.imageNameArray removeObjectAtIndex:indexPath.row];
    //concatenate the docsDirectory and the filename
    NSString *imagePath = [docsDir stringByAppendingPathComponent:imageName];
    NSError *error;
    [[NSFileManager defaultManager]removeItemAtPath:imagePath error:&error];
    
    if (error)
    {
        NSLog(@"file deletion failed");
    }
    [tableView reloadData];
}
@end
