//
//  EquationPickerViewController.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/16/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "EquationPickerViewController.h"
#import "EquationPickerCell.h"
@import PopOverMenu;

@interface EquationPickerViewController ()<UITableViewDelegate,UITableViewDataSource, PopoverEquationCellDelegate, UIAdaptivePresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *equationSnips;

@end

@implementation EquationPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl =[[UIRefreshControl alloc] init];
       [self.refreshControl addTarget:self action:@selector(fetchEquationSnips) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView addSubview:self.refreshControl];
       NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    
    [self fetchEquationSnips];
}
- (void)fetchEquationSnips{
    PFQuery *query = [PFQuery queryWithClassName:@"EquationSnips"];
       [query orderByDescending:@"updatedAt"];
       [query whereKey:@"author" equalTo:[PFUser currentUser]];
           // fetch data asynchronously
           [query findObjectsInBackgroundWithBlock:^(NSArray *equationsArray, NSError *error) {
               if (equationsArray != nil) {
                   self.equationSnips = equationsArray;
                   [self.tableView reloadData];
                   [self.refreshControl endRefreshing];
               } else {
               }
           }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    EquationPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EquationPickerCell" forIndexPath:indexPath];
    cell.equationSnip = self.equationSnips[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.equationSnips.count;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:^{
        EquationSnip *equationSnip = self.equationSnips[indexPath.row];
        [self.delegate didPickEquationSnip:equationSnip withMode:@"Inline"];
    }];
    
}

#pragma mark - EquationPickerCell Delegate

- (void)tapOnEquation:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(EquationPickerCell *)sender];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tapOnMenu:(UIButton *)button forEquationSnip:(EquationSnip *) equationSnip {
    
    NSArray *titles = @[@"Inline", @"Display"];
    NSArray *descriptions = @[@"Insert the equation inline", @"Insert the equation in a new line aligned to the center"];
    
    PopOverViewController *popOverViewController = [PopOverViewController instantiate];
    
    [popOverViewController setWithTitles:titles];
    [popOverViewController setWithDescriptions:descriptions];
    
    popOverViewController.popoverPresentationController.sourceView = button;
    popOverViewController.preferredContentSize = CGSizeMake(400, 90);
    popOverViewController.presentationController.delegate = self;
    
    [popOverViewController setCompletionHandler:^(NSInteger selectRow) {
        switch (selectRow) {
            case 0:
                [self.delegate didPickEquationSnip:equationSnip withMode:@"Inline"];
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
            case 1:
                [self.delegate didPickEquationSnip:equationSnip withMode:@"Display"];
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
            default:
                break;
        }
    }];
    
    [self presentViewController:popOverViewController animated:YES completion:nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone;
}


/*
 #pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
