# Blockchain-Based Wetland Conservation Management System

A comprehensive blockchain solution for transparent, verifiable, and decentralized wetland conservation management. This system leverages smart contracts to ensure accountability, track conservation efforts, and promote sustainable wetland protection practices.

## 🌿 Overview

The Wetland Conservation Management System uses blockchain technology to create an immutable record of conservation activities, enabling stakeholders to verify conservation efforts, track ecosystem health, and ensure proper resource allocation for wetland protection.

## 🏗️ System Architecture

The system consists of five interconnected smart contracts:

### 1. Wetland Verification Contract
- **Purpose**: Validates and registers conservation areas
- **Features**:
    - GPS coordinate verification
    - Legal ownership validation
    - Conservation status certification
    - Area measurement and boundary definition
    - Multi-party verification process

### 2. Ecosystem Monitoring Contract
- **Purpose**: Tracks wetland health metrics and environmental data
- **Features**:
    - Water quality measurements (pH, dissolved oxygen, turbidity)
    - Vegetation health indices
    - Pollution level monitoring
    - Climate data integration
    - Automated alert system for threshold breaches

### 3. Conservation Activity Contract
- **Purpose**: Records and validates protection efforts
- **Features**:
    - Activity logging (cleanup, maintenance, protection measures)
    - Resource allocation tracking
    - Volunteer participation records
    - Equipment and material usage
    - Impact assessment documentation

### 4. Biodiversity Tracking Contract
- **Purpose**: Monitors species populations and ecosystem diversity
- **Features**:
    - Species census data
    - Migration pattern tracking
    - Endangered species monitoring
    - Habitat quality assessment
    - Breeding success rates

### 5. Restoration Verification Contract
- **Purpose**: Validates wetland restoration projects
- **Features**:
    - Before/after comparison metrics
    - Restoration milestone tracking
    - Success rate verification
    - Long-term monitoring integration
    - Certification of completed projects

## 🚀 Getting Started

### Prerequisites

- Node.js (v16.0.0 or higher)
- Ethereum development environment (Hardhat/Truffle)
- MetaMask or compatible Web3 wallet
- IPFS node (for storing large environmental data)

### Installation

```bash
# Clone the repository
git clone https://github.com/your-org/wetland-conservation-blockchain.git
cd wetland-conservation-blockchain

# Install dependencies
npm install

# Install additional blockchain dependencies
npm install @openzeppelin/contracts hardhat @nomiclabs/hardhat-ethers

# Install IPFS integration
npm install ipfs-http-client
```

### Environment Setup

Create a `.env` file in the project root:

```env
# Blockchain Network Configuration
NETWORK_URL=https://your-ethereum-node-url
PRIVATE_KEY=your-private-key-here
CONTRACT_ADDRESSES_FILE=./deployed-contracts.json

# IPFS Configuration
IPFS_GATEWAY=https://ipfs.io/ipfs/
IPFS_API_URL=https://ipfs.infura.io:5001

# API Keys
WEATHER_API_KEY=your-weather-api-key
SATELLITE_DATA_API_KEY=your-satellite-api-key
```

### Smart Contract Deployment

```bash
# Compile contracts
npx hardhat compile

# Deploy to local network
npx hardhat run scripts/deploy.js --network localhost

# Deploy to testnet
npx hardhat run scripts/deploy.js --network goerli

# Verify contracts on Etherscan
npx hardhat verify --network goerli CONTRACT_ADDRESS
```

## 📋 Usage

### 1. Registering a Wetland

```javascript
// Connect to the Wetland Verification Contract
const wetlandContract = await ethers.getContractAt("WetlandVerification", contractAddress);

// Register a new wetland
await wetlandContract.registerWetland(
  "Wetland Name",
  [latitude, longitude], // GPS coordinates
  areaInHectares,
  ownerAddress,
  conservationStatus
);
```

### 2. Recording Ecosystem Data

```javascript
// Connect to Ecosystem Monitoring Contract
const monitoringContract = await ethers.getContractAt("EcosystemMonitoring", contractAddress);

// Submit monitoring data
await monitoringContract.recordEcosystemData(
  wetlandId,
  {
    waterQuality: { pH: 7.2, dissolvedOxygen: 8.5, turbidity: 2.1 },
    vegetationHealth: 85,
    pollutionLevel: 1,
    timestamp: Date.now()
  }
);
```

### 3. Logging Conservation Activities

```javascript
// Connect to Conservation Activity Contract
const activityContract = await ethers.getContractAt("ConservationActivity", contractAddress);

// Log a conservation activity
await activityContract.logActivity(
  wetlandId,
  "Invasive Species Removal",
  "Removed 500kg of invasive water hyacinth",
  volunteersInvolved,
  resourcesUsed,
  impactMetrics
);
```

### 4. Tracking Biodiversity

```javascript
// Connect to Biodiversity Tracking Contract
const biodiversityContract = await ethers.getContractAt("BiodiversityTracking", contractAddress);

// Record species census
await biodiversityContract.recordSpeciesCensus(
  wetlandId,
  speciesName,
  populationCount,
  observationDate,
  observerCredentials
);
```

### 5. Verifying Restoration Projects

```javascript
// Connect to Restoration Verification Contract
const restorationContract = await ethers.getContractAt("RestorationVerification", contractAddress);

// Submit restoration milestone
await restorationContract.submitMilestone(
  projectId,
  milestoneDescription,
  completionPercentage,
  verificationData,
  photosIPFSHash
);
```

## 🔧 API Reference

### Core Functions

#### Wetland Verification
- `registerWetland()` - Register a new wetland conservation area
- `verifyWetland()` - Verify wetland registration by authorized validators
- `updateWetlandStatus()` - Update conservation status
- `getWetlandDetails()` - Retrieve wetland information

#### Ecosystem Monitoring
- `recordEcosystemData()` - Submit environmental monitoring data
- `setThresholds()` - Configure alert thresholds
- `getHealthScore()` - Calculate ecosystem health score
- `generateReport()` - Create ecosystem health reports

#### Conservation Activity
- `logActivity()` - Record conservation activities
- `validateActivity()` - Verify activity completion
- `trackResources()` - Monitor resource utilization
- `calculateImpact()` - Assess conservation impact

#### Biodiversity Tracking
- `recordSpeciesCensus()` - Log species population data
- `trackMigration()` - Record migration patterns
- `monitorEndangered()` - Special tracking for endangered species
- `assessHabitat()` - Evaluate habitat quality

#### Restoration Verification
- `initiateProject()` - Start restoration project
- `submitMilestone()` - Record project milestones
- `verifyCompletion()` - Validate project completion
- `certifyRestoration()` - Issue restoration certificates

## 📊 Data Storage

### On-Chain Data
- Contract addresses and configurations
- Verification status and certifications
- Critical metrics and thresholds
- Activity logs and timestamps
- Validator signatures and approvals

### Off-Chain Data (IPFS)
- High-resolution photos and videos
- Detailed scientific reports
- Large datasets (satellite imagery)
- Historical documentation
- Multimedia evidence

## 🔐 Security Features

- **Multi-signature validation** for critical operations
- **Role-based access control** for different user types
- **Data integrity verification** using cryptographic hashes
- **Timestamp verification** to prevent backdating
- **Consensus mechanisms** for disputed measurements

## 🌐 Stakeholder Roles

### Conservation Organizations
- Register and manage wetland areas
- Submit conservation activity reports
- Access ecosystem health data
- Coordinate restoration projects

### Environmental Scientists
- Submit monitoring data and research findings
- Validate ecosystem health metrics
- Provide expert verification for restoration projects
- Access historical data for research

### Government Agencies
- Verify legal compliance and permits
- Access conservation status reports
- Monitor regulatory compliance
- Provide official certifications

### Local Communities
- Report environmental observations
- Participate in conservation activities
- Access transparency reports
- Contribute to citizen science initiatives

## 📈 Monitoring and Analytics

### Key Performance Indicators (KPIs)
- Wetland area under protection
- Ecosystem health improvement rates
- Species population recovery
- Conservation activity frequency
- Restoration project success rates

### Reporting Features
- Real-time dashboard with conservation metrics
- Automated alert system for environmental threats
- Progress tracking for conservation goals
- Impact assessment reports
- Stakeholder activity summaries

## 🤝 Contributing

We welcome contributions from developers, conservationists, and environmental scientists. Please read our contributing guidelines and code of conduct before submitting pull requests.

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass
5. Submit a pull request with detailed description

### Testing
```bash
# Run smart contract tests
npx hardhat test

# Run integration tests
npm run test:integration

# Check code coverage
npx hardhat coverage
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support, please contact:
- Email: support@wetlandconservation.org
- Discord: [Conservation Tech Community](https://discord.gg/conservation-tech)
- Documentation: [docs.wetlandconservation.org](https://docs.wetlandconservation.org)

## 🙏 Acknowledgments

- Environmental Protection Agency for regulatory guidance
- WWF for conservation best practices
- Ethereum Foundation for blockchain infrastructure
- IPFS for decentralized storage solutions
- OpenZeppelin for secure smart contract frameworks

---

**Together, we can preserve our wetlands for future generations through transparent, accountable, and technology-driven conservation efforts.**
