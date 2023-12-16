# terraform-azure-peered-vnets
My Terraform project to create Azure Vnets. subnets, linux vms and vnet peerings.

**Description**

The Rand Enterprises Corporation is evaluating Azure as a deployment platform. To help the company with its evaluation, you need to create virtual networks in the region specified by Rand Enterprises Corporation. You have to create test virtual machines in two virtual networks, establish connectivity between the two networks via VNet peering, and ensure connectivity is established properly.

To test the platform, Rand Enterprises Corporation wants to onboard an employee on the company’s default Azure Active Directory and assign a Custom RBAC role, under which they will be able to read the network and storage along with the VM. Under this custom RBAC, the employee should also be given permission to start and restart the VM. You have to onboard the employee under the default Azure AD and create a custom RBAC for the role of computer operator for this employee.

As a security measure, you need to ensure that the onboarded user can only access the resources mentioned in the custom role and adhere to the principle of least privilege.

**Expected Deliverables:**

**Step 1 Create Environment **
1. Identify the networks
2. Workload deployed to these networks
3. Establishing the connectivity between these networks

**Step 2 - User Onboarding **   
5. Onboard a user(s)
6. Create and assign a custom role to the user

**Step 3 - Testing**
7. Testing if user VM opersations
  1. User can stop/restart vm
  2. User cannot delete vm

