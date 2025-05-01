#!/bin/bash

set -e  # Exit on error

echo "📦 Step 1: Setting system locale to UTF-8..."
sudo apt update && sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
locale

echo "📁 Step 2: Adding universe repository..."
sudo apt install -y software-properties-common
sudo add-apt-repository universe

echo "🌐 Step 3: Adding ROS 2 apt repository..."
sudo apt update && sudo apt install -y curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "📄 Adding ROS 2 repo to apt sources..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

echo "🔄 Step 4: Updating and upgrading system..."
sudo apt update
sudo apt upgrade -y

echo "🤖 Step 5: Choose the ROS 2 Humble installation type:"
echo "1) ros-humble-ros-base (recommended for robots/headless systems)"
echo "2) ros-humble-desktop (includes Rviz, Gazebo, etc.)"
read -p "Enter choice [1 or 2]: " choice

case $choice in
  1)
    echo "Installing ros-humble-ros-base..."
    sudo apt install -y ros-humble-ros-base
    ;;
  2)
    echo "Installing ros-humble-desktop..."
    sudo apt install -y ros-humble-desktop
    ;;
  *)
    echo "❌ Invalid choice. Exiting."
    exit 1
    ;;
esac

echo "🛠️ Step 6: Installing ROS development tools..."
sudo apt install -y ros-dev-tools

echo "🔧 Step 7: Setting up ROS 2 environment..."
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
source /opt/ros/humble/setup.bash

echo "✅ ROS 2 Humble installation and environment setup complete!"

