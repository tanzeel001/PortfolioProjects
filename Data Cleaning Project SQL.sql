Select *
from PortfolioProject..NashvilleHousing


--CONVERT DATE FORMAT FROM DATETIME TO DATE.

Select Saledate 
from PortfolioProject..NashvilleHousing


Select saledate, convert(Date, SaleDate)
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SaleDate = CONVERT (Date, SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT (Date, SaleDate)

Select *
from PortfolioProject..NashvilleHousing


--POPULATE PROPERTY ADDRESS DATA
Select *
from PortfolioProject..NashvilleHousing
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS(ADDRESS, CITY, STATE)
--DELIMINAR IS SOMETHING THAT SEPARATES TWO COLUMNS

Select PropertyAddress
from PortfolioProject..NashvilleHousing
--ORDER BY ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
--CHARINDEX(',', PropertyAddress)
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From PortfolioProject..NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar (255);

Update NashvilleHousing
Set PropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PROPERTYADDRESS) -1)

Alter Table NashvilleHousing
Add PropertySplitCITY nvarchar (255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PROPERTYADDRESS) + 1, LEN(PropertyAddress)) 

Select *
from PortfolioProject..NashvilleHousing


--NOW OWNER ADDRESS BUT WITHOUT SUBSTRING
--USING PARENAME

Select 
Parsename(OwnerAddress,1)
from PortfolioProject..NashvilleHousing


Select OwnerAddress
from PortfolioProject..NashvilleHousing


Select Parsename (Replace(OwnerAddress, ',', '.'), 3)
, Parsename (Replace(OwnerAddress, ',', '.'), 2)
, Parsename (Replace(OwnerAddress, ',', '.'), 1)
from PortfolioProject..NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar (255);

Update NashvilleHousing
Set OwnersplitAddress = Parsename(Replace(OwnerAddress, ',', '.') , 3)

Alter Table NashvilleHousing
Add OwnerSplitCITY nvarchar (255);

Update NashvilleHousing
Set OwenersplitCity = Parsename (Replace(OwnerAddress, ',', '.'), 2)


Alter Table NashvilleHousing
Add ownerSplitstate nvarchar (255);

Update NashvilleHousing
Set Ownersplitstate = Parsename (Replace(OwnerAddress, ',', '.'), 1)

select *
from PortfolioProject..NashvilleHousing

--CHANGE Y & N TO YES & NO IN SOLD VACANT FIELD

Select Distinct (soldASVacant), Count(soldASVacant)
from PortfolioProject..NashvilleHousing
group by soldASVacant
order by 2

Select soldASVacant
,Case when soldASVacant = 'Y' then 'YES'
 when soldASVacant = 'N' then 'NO'
ELSE SoldAsVacant
END
from PortfolioProject..NashvilleHousing
--group by soldASVacant
--order by 2

UPDATE NashvilleHousing
SET SOLDASVACANT = Case when soldASVacant = 'Y' then 'YES'
                   when soldASVacant = 'N' then 'NO'
                   ELSE SoldAsVacant
                   END
from PortfolioProject..NashvilleHousing

--REMOVE DUPLICATES

With RowNumCTE AS(
Select *,
	Row_Number() Over (
	Partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
	Order by
				UniqueID
			) row_num
			From PortfolioProject..NashvilleHousing
			)
			select *
			from rowNumCTE
			where row_num > 1
		--	order by propertyaddress
			
			

--DELETE UNUSED COLUMNS
Select *
from PortfolioProject..NashvilleHousing

Alter table portfolioproject..nashvillehousing
drop column owneraddress, taxdistrict, propertyaddress

Alter table portfolioproject..nashvillehousing
drop column Saledate




























