Select* 
From PortfolioProject1.dbo.NashvilleHousing


Select SaleDateConverted, CONVERT(Date,SaleDate) 
From PortfolioProject1.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date; 

Update NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)



--Populate Property Address data

Select * 
	From PortfolioProject1.dbo.NashvilleHousing
	--where PropertyAddress is not null 
	order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull( a.PropertyAddress, b.PropertyAddress) 
	From PortfolioProject1.dbo.NashvilleHousing as a
	join PortfolioProject1.dbo.NashvilleHousing  as b
		on a.ParcelID = b.ParcelID
		and a.[UniqueID ]<> b.[UniqueID ]
	where a.PropertyAddress is null

update a 
SET PropertyAddress = ISNULL ( a.PropertyAddress, b.PropertyAddress)
From PortfolioProject1.dbo.NashvilleHousing as a
	join PortfolioProject1.dbo.NashvilleHousing  as b
		on a.ParcelID = b.ParcelID
		and a.[UniqueID ]<> b.[UniqueID ]
	where a.PropertyAddress is null


--Breaking out Address into Individual Coulmns (Address, City, State) 


Select PropertyAddress
	From PortfolioProject1.dbo.NashvilleHousing
	--where PropertyAddress is not null 
	--order by ParcelID

Select 
	SUBSTRING( PropertyAddress,1, CHARINDEX(',', propertyAddress) -1) as Address,
	SUBSTRING( PropertyAddress, CHARINDEX(',', propertyAddress) +1,  LEN(propertyaddress)) as Address

		From PortfolioProject1.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255); 

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING( PropertyAddress,1, CHARINDEX(',', propertyAddress) -1)

Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255); 

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING( PropertyAddress, CHARINDEX(',', propertyAddress) +1,  LEN(propertyaddress))

select* 
		From PortfolioProject1.dbo.NashvilleHousing








select OwnerAddress
		From PortfolioProject1.dbo.NashvilleHousing


Select 
PARSENAME(replace(OwnerAddress,',','.'), 3) 
,PARSENAME(replace(OwnerAddress,',','.'), 2) 
,PARSENAME(replace(OwnerAddress,',','.'), 1) 
	From PortfolioProject1.dbo.NashvilleHousing




	Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar(255); 

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'), 3) 

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255); 

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'), 2) 

Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255); 

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'), 1) 


Select * 
From PortfolioProject1.dbo.NashvilleHousing



-- Change Y and N to Yes and No in "Sold as Vacant" field 

Select distinct(SoldAsVacant), COUNT(SoldAsVacant)

	From PortfolioProject1.dbo.NashvilleHousing
	
	Group by 
		SoldAsVacant
	Order by
		2






Select SoldAsVacant
, Case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end 
From PortfolioProject1.dbo.NashvilleHousing



Update NashvilleHousing

	Set SoldAsVacant =  Case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end 



	
-- Remove Duplicates 


With RowNumCTE AS(
Select * , 
		ROW_NUMBER() over (
		partition by  ParcelID, 
							PropertyAddress,
							SalePrice,
							SaleDate,
							LegalReference
							Order by 
								UniqueID
								) row_num

	From PortfolioProject1.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
where row_num > 1 
order by PropertyAddress




Select * 
	From 
		PortfolioProject1.dbo.NashvilleHousing





-- Delete Unused Columns 

Select * 
	From 
		PortfolioProject1.dbo.NashvilleHousing


Alter Table PortfolioProject1.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject1.dbo.NashvilleHousing
Drop Column SaleDate