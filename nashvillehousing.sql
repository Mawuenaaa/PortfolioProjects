										-- Data Cleaning In SQL 

-- SKILLS USED: Self-JOIN, IFNULL function, substring_index function, Case Statement  
-------------------------------------------------------------------------------------------------------------------------------------------
-- STEP 1: Populating Property Address Column 

SELECT a.parcelID, a.propertyAddress, b.ParcelID, b.PropertyAddress, IFNULL(a.propertyAddress, b.propertyAddress) as address
FROM nashvillehousing a 
JOIN nashvillehousing b ON a.parcelID = b.parcelID
WHERE a.uniqueID != B.uniqueID
AND a.PropertyAddress IS NULL
ORDER BY a.parcelid;

update nashvillehousing a 
JOIN nashvillehousing b ON a.parcelID = b.parcelID
set a.propertyaddress = IFNULL(a.propertyAddress, b.propertyAddress)
WHERE a.uniqueID != B.uniqueID
AND a.PropertyAddress IS NULL;

----------------------------------------------------------------------------------------------------------------------------------------
 
 -- STEP 2: Breaking Out Address Column Into Individual Columns namely Address, City, State 
 
-- select PropertyAddress FROM nashvillehousing;

select substring(PropertyAddress, 1, locate(',', PropertyAddress)-1) as SplitAddress
from nashvillehousing ;

select substring(PropertyAddress, locate(',', PropertyAddress)+1) as SplitAddressCity
from nashvillehousing;

------------------------------------------------------------------------------------------------------------------------------------------

-- STEP 3: Inserting Newly-reated Split Columns Into Nashvillehousing Table 

Alter table nashvillehousing 
ADD COLUMN SplitAddress VARCHAR(255) NOT NULL AFTER PropertyAddress;

UPDATE nashvillehousing
SET SplitAddress = substring(PropertyAddress, 1, locate(',', PropertyAddress)-1);

Alter table nashvillehousing 
ADD COLUMN SplitAddressCity VARCHAR(255) NOT NULL AFTER SplitAddress;

UPDATE nashvillehousing
SET SplitAddressCity = substring(PropertyAddress, locate(',', PropertyAddress)+1);

---------------------------------------------------------------------------------------------------------------------------------------------

-- STEP 4: SPLITTING OWNERADDRESS COLUMN

select 
substring_index(OwnerAddress, ',', 1) as OwnerAddressSplit, 
substring_index(substring_index(OwnerAddress, ',', -2), ',', 1)as OwnerAddressSplitCity,
substring_index(OwnerAddress, ',', -1)as OwnerAddressSplitState
from nashvillehousing;

----------------------------------------------------------------------------------------------------------------------------------------------
-- STEP 5: Altering & Updating Nashvillehousing Table To Include Newly-created Columns From OwnerAddress Column Split

ALTER TABLE nashvillehousing
ADD COLUMN OwnerAddressSplit NVARCHAR(255) AFTER OwnerAddress,
ADD COLUMN OwnerAddressSplitCity NVARCHAR(255) AFTER OwnerAddressSplit,
ADD COLUMN OwnerAddressSplitState NVARCHAR(255) AFTER OwnerAddressSplitCity
;

UPDATE Nashvillehousing
SET 
OwnerAddressSplit = substring_index(OwnerAddress, ',', 1);
				
UPDATE Nashvillehousing
SET 
OwnerAddressSplitCity = substring_index(substring_index(OwnerAddress, ',', -2), ',', 1);

UPDATE Nashvillehousing
SET 
OwnerAddressSplitState = substring_index(OwnerAddress, ',', -1);

---------------------------------------------------------------------------------------------------------------------------------------------------

-- STEP 6: Changing Y and N records in SoldAsVacant Column to Yes and No respectively. 

select
case SoldAsVacant
when 'N' then 'No'
when 'Y' then 'Yes'
else SoldAsVacant
END AS SoldAsVacantEdited
from nashvillehousing;

-- Creating a new column in nashvillehousing table to store edited SoldAsVacant column edited records
alter table nashvillehousing
add column SoldAsVacantEdited text AFTER SoldAsVacant;

update nashvillehousing
set SoldAsVacantEdited = case SoldAsVacant
when 'N' then 'No'
when 'Y' then 'Yes'
else SoldAsVacant
END; 

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- DELETING UNUSED COLUMNS FROM NASHVILLE HOUSING TABLE 

Alter table nashvillehousing
drop column PropertyAddress,
drop column SoldAsVacant,
drop column OwnerAddress,
drop column TaxDistrict;

select * from nashvillehousing 

