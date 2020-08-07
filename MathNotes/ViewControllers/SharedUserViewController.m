//
//  SharedUserViewController.m
//  MathNotes
//
//  Created by Nikesh Subedi on 8/6/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "SharedUserViewController.h"
#import "SharedUserCell.h"
#import "Note.h"
#import "EquationSnip.h"
#import "SharedNote.h"
#import "SharedEquationSnip.h"

@interface SharedUserViewController ()<UITableViewDelegate,UITableViewDataSource, SharedUserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *users;

@end

@implementation SharedUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self fetchUsers];
}

- (void)fetchUsers{
    self.users = [[NSMutableArray alloc] init];
    if ([self.sharedObject isKindOfClass:[Note class]]){
        PFQuery *query = [PFQuery queryWithClassName:@"SharedNotes"];
        [query whereKey:@"sharedNote" equalTo:self.sharedObject];
        [query includeKey:@"sharedUser"];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable resultNotes, NSError * _Nullable error) {
            if (error == nil){
                for (SharedNote *sharedNote in resultNotes){
                    [self.users addObject:sharedNote.sharedUser];
                }
                [self.tableView reloadData];
            }
        }];
    }
    else if ([self.sharedObject isKindOfClass:[EquationSnip class]]){
        PFQuery *query = [PFQuery queryWithClassName:@"SharedEquationSnips"];
        [query whereKey:@"sharedEquationSnip" equalTo:self.sharedObject];
        [query includeKey:@"sharedUser"];
           [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable resultEquationSnips, NSError * _Nullable error) {
               if (error == nil){
                   for (SharedEquationSnip *sharedEquationSnip in resultEquationSnips){
                       [self.users addObject:sharedEquationSnip.sharedUser];
                   }
                   [self.tableView reloadData];
               }
           }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SharedUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SharedUserCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.sharedUser = self.users[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (void)didDeleteUser:(nonnull PFUser *)user withSender:(nonnull id)sender{
    if ([self.sharedObject isKindOfClass:[Note class]]){
        [SharedNote deleteSharedNote:(Note *)self.sharedObject forUser:user withCompletion:nil];
        
    }
    else if ([self.sharedObject isKindOfClass:[EquationSnip class]]) {
        [SharedEquationSnip deleteSharedEquationSnip:(EquationSnip *)self.sharedObject forUser:user withCompletion:nil];
    }
    [self.tableView beginUpdates];
    NSIndexPath *indexPath =[self.tableView indexPathForCell:(SharedUserCell *)sender];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.users removeObjectAtIndex:indexPath.row];
    [self.tableView endUpdates];
    if (self.users.count==0) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate updateTable];
        }];
    }
}
@end
