# terraform-azure-peered-vnets
My Terraform project to create Azure Vnets. subnets, linux vms and vnet peerings.

## Description

The Rand Enterprises Corporation is evaluating Azure as a deployment platform. To help the company with its evaluation, you need to create virtual networks in the region specified by Rand Enterprises Corporation. You have to create test virtual machines in two virtual networks, establish connectivity between the two networks via VNet peering, and ensure connectivity is established properly.

To test the platform, Rand Enterprises Corporation wants to onboard an employee on the company’s default Azure Active Directory and assign a Custom RBAC role, under which they will be able to read the network and storage along with the VM. Under this custom RBAC, the employee should also be given permission to start and restart the VM. You have to onboard the employee under the default Azure AD and create a custom RBAC for the role of computer operator for this employee.

As a security measure, you need to ensure that the onboarded user can only access the resources mentioned in the custom role and adhere to the principle of least privilege.

## Expected Deliverables

1. Identify the networks
2. Workload deployed to these networks
3. Establishing the connectivity between these networks
4. Onboard a user
5. Create and assign a custom role to the user


## Solution Architecture

![Solution Architecture](./screenshots/01-%20randcorp-solution-architecture-in-azure.png)

## Azure Network Topology

![Network Topology](./screenshots/02-%20randcorp-azure-network-topology-01.png)


## Pre-Requisites (accounts & software)

1. Microsoft Azure Account
2. GitHub account
3. Azure CLI
4. Terraform

## High level Steps

1. Provision Azure network infrastructure
   
   Identify the networks, establish connectivity between these networks, workload deployment to these networks 
   validation

2. Provision user, RBAC Role
   
   Onboard users via terraform scripts, create and assisgn custom RBAC azure role to the user
   validation


### Step 1- Provision Azure network infrastructure

1. Create AZURE Resource Group
2. Create AZURE Vnet(s), 1 subnet in each Vnet
3. CREATE AZURE NSG, NSG Association
4. Create Peering between two vnet(s)
5. Create 2 PIP, 2 NIC
6. Create 2 Linux VMs in subnet(s)
7. Validate above steps

### Step 2 - Provision user, RBAC Role
8. Create Users
9. Create custom RBAC Role
10. Assign role to user
11. Validation
- Validate if the test user can log in to the azure portal
- Validate if the test user is forced to reset the password on the first login
- Validate if test user can view vms per rbac role assignment
- Validate if test user can stop vm - expected result – fail
- Validate if test user can restart vm - expected result - success
- 

