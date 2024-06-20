// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/*
 * @author not-so-secure-dev
 * @title PasswordStore
 * @notice This contract allows you to store a private password that others won't be able to see. 
 * You can update your password at any time.
 */

 // 1. High Level Overview - Gain understanding of the codebase
 // 2. Entry Points - What functions can a user interact with
 // 3. Business Logic - What the contract is supposed to do vs what is can do ( assess all possibilites )

 // AUDIT TAGS:
 // @audit - potential problems
 // @audit-issue - bug 
 // @audit-info - context

contract PasswordStore {

    error PasswordStore__NotOwner();

    // @audit-info two state variables
    address private s_owner;
    string private s_password; // @audit-issue storing passowrd onchain is not safe

    event SetNetPassword();

    constructor() {
        // @audit-info deployer is owner
        s_owner = msg.sender;
    }

    /*
     * @notice This function allows only the owner to set a new password.
     * @param newPassword The new password to set.
     */

     /* @audit-info function , high likelyhood of finding bugs here.
     -May require "require" as we need the only deployer of smart contract making changes.
     -Missing access control.
     - Read and write accesssibility of contract needs to be reviewed 
     */

    function setPassword(string memory newPassword) external {
        /* @audit-issue Access control not in place to specify only owner being able to call contract
        (This could lead to malactors accessing function within contract)
        
        Implications - Anyone else aside owner can modify password*/

        /*require(msg.sender == s_owner, "Not owner");
         */
        s_password = newPassword;
        emit SetNetPassword();
    }

    /*
     * @notice This allows only the owner to retrieve the password.
     * @param newPassword The new password to set. @audit - this documentation is incorrect
     */

     /*audit-info
     - Check read and write priviledges for function(Needs to be the owner only)
     */
    function getPassword() external view returns (string memory) {
        if (msg.sender != s_owner) {
            revert PasswordStore__NotOwner();
        }
        return s_password;
    }
}

