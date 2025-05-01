#!/bin/bash

set -e  # Exit on error

# Step 1: Prompt for installation type early on
echo "🤖 Step 1: Choose the ROS 2 Humble installation type:"
echo "1) ros-humble-ros-base (recommended for robots/headless systems)"
echo "2) ros-humble-desktop (includes Rviz, Gazebo, etc.)"
read -p "Enter choice [1 or 2]: " choice

# Step 2: Setting system locale to UTF-8
echo "📦 Step 2: Setting system locale to UTF-8..."
sudo apt update && sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
locale

# Step 3: Adding universe repository
echo "📁 Step 3: Adding universe repository..."
sudo apt install -y software-properties-common
sudo add-apt-repository -y universe  # -y to automatically accept

# Step 4: Adding ROS 2 apt repository
echo "🌐 Step 4: Adding ROS 2 apt repository..."
sudo apt update && sudo apt install -y curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "📄 Adding ROS 2 repo to apt sources..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Step 5: Updating and upgrading system
echo "🔄 Step 5: Updating and upgrading system..."
sudo apt update
sudo apt upgrade -y  # -y to auto-confirm upgrade

# Step 6: Install selected ROS 2 package based on choice
echo "🤖 Step 6: Installing selected ROS 2 package..."

case $choice in
  1)
    echo "Installing ros-humble-ros-base..."
    sudo apt install ros-humble-ros-base
    ;;
  2)
    echo "Installing ros-humble-desktop..."
    sudo apt install ros-humble-desktop
    ;;
  *)
    echo "❌ Invalid choice. Exiting."
    exit 1
    ;;
esac

# Step 7: Installing ROS development tools
echo "🛠️ Step 7: Installing ROS development tools..."
sudo apt install -y ros-dev-tools

# Step 8: Setting up ROS 2 environment
echo "🔧 Step 8: Setting up ROS 2 environment..."
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
source /opt/ros/humble/setup.bash

echo "✅ ROS 2 Humble installation and environment setup complete!"
