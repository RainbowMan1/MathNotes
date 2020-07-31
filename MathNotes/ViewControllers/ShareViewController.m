//
//  ShareNoteViewController.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/30/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "ShareViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UIImageView+AFNetworking.h"
#import "ShareCell.h"
#import "Friend.h"

@interface ShareViewController()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSMutableArray *currentFriends;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    // Do any additional setup after loading the view.
    [self fetchFriends];
}

-(void)fetchFriends{

    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    self.friends = [[NSMutableArray alloc] init];
     FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
            initWithGraphPath:@"/me"
                   parameters:@{ @"fields": @"id,name,friends",}
                   HTTPMethod:@"GET"];
    
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            NSLog(@"%@",result);
            for (NSDictionary * friend in result[@"friends"][@"data"]){
                dispatch_group_enter(dispatchGroup);
                Friend *currFriend = [[Friend alloc] init];
                currFriend.friendName = friend[@"name"];
                currFriend.FBID =friend[@"id"];
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                    initWithGraphPath:[@"/" stringByAppendingString:friend[@"id"]]
                           parameters:@{ @"fields": @"picture"}
                           HTTPMethod:@"GET"];
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    currFriend.friendProfilePicImageURL = result[@"picture"][@"data"][@"url"];
                    [self.friends addObject:currFriend];
                    dispatch_group_leave(dispatchGroup);
                }];
            }
            dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
                self.currentFriends = [[NSMutableArray alloc] initWithArray:self.friends];
                [self.tableView reloadData];
            });
        }];
    
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareCell" forIndexPath:indexPath];
    cell.shareFriend = self.currentFriends[indexPath.row];
    
    return cell;
}
- (IBAction)shareByUsername:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate didShareToUsername];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Friend *selectedFriend = self.currentFriends[indexPath.row];
    [self.delegate didShareToFBID:selectedFriend.FBID];
    [self dismissViewControllerAnimated:YES completion:nil];
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
