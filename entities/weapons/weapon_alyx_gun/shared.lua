
PRIMARY_SLOT		= 0;
SECONDARY_SLOT		= 1;

local SMG_MODE = 0
local PISTOL_MODE = 1
local RIFLE_MODE = 2

SWEP.Author			= "Whoever";
SWEP.PrintName		= "Alyx Gun";

SWEP.ViewModelFOV	= 70;
SWEP.ViewModelFlip	= false;
SWEP.ViewModel		= "models/weapons/v_smg1.mdl";
SWEP.WorldModel		= "models/weapons/w_alyx_gun.mdl";
SWEP.HoldType		= "smg";

SWEP.WeaponSlot		= PRIMARY_SLOT;

SWEP.Primary.Damage			= 10;
SWEP.Primary.ClipSize		= 30;
SWEP.Primary.DefaultClip	= 999;
SWEP.Primary.Automatic		= true;
SWEP.Primary.Ammo			= "smg1";
SWEP.Primary.Sound			= Sound( "Weapon_SMG1.Single" );

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetDeploySpeed( 1.0 );
	self:SetHoldType( self.HoldType );
	self:SetMode(SMG_MODE)
end

function SWEP:SetupDataTables()
    self:NetworkVar("Int", 0, "Mode")
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW );
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
	if self:GetMode() == SMG_MODE then
		self:EmitSound( self.Primary.Sound );
	elseif self:GetMode() == PISTOL_MODE then
		self:EmitSound( "weapons/alyx_gun/alyx_gun_fire3.wav" );
	else
		self:EmitSound( "Weapon_357.Single" );
	end
	self:MuzzleFlash();
	
	self:ShootBullet();
	
	if self:GetMode() == SMG_MODE then
		self:SetNextPrimaryFire( CurTime() + 0.085 );
	elseif self:GetMode() == PISTOL_MODE then
		self:SetNextPrimaryFire( CurTime() + 0.16 );
	else
		self:SetNextPrimaryFire(CurTime() + 1)
	end
end

function SWEP:ShootBullet( pl )
	local spread = 0.03;
	local recoil = 0.3;
	
	local bullet = {}
		bullet.Num 		  = self.NumShots;
		bullet.Src 		  = self.Owner:GetShootPos();
		bullet.Dir 		  = self.Owner:GetAimVector();
		bullet.Spread 	  = Vector(spread, spread, 1);
		bullet.Tracer	  = 1;
		bullet.TracerName = TracerName;
		bullet.Force	  = self.Primary.Damage * 0.5;
		bullet.AmmoType   = self.Primary.Ammo;
	if self:GetMode(SMG_MODE) then
		bullet.Damage	  = self.Primary.Damage;
	elseif (PISTOL_MODE) then
		bullet.Spread 	  = Vector(0.01, 0.01, 0.01);
		bullet.Damage	  = self.Primary.Damage * 2;
	else
		bullet.Spread 	  = Vector(0, 0, 0);
		bullet.Damage	  = self.Primary.Damage * 4;
	end
	
	recoil = Angle( math.Rand(-recoil, 0), math.Rand(-recoil, recoil), math.Rand(-0.2, 0.2) );
	
	self.Owner:ViewPunchReset( 1 );
	self.Owner:ViewPunch( recoil );
	self.Owner:FireBullets( bullet );
	self:TakePrimaryAmmo( 1 );
end

function SWEP:SecondaryAttack()
	// ORDER IS PISTOL - SMG - RIFLE
	if self:GetMode() == SMG_MODE then
		// switch to rifle mode
		self.Owner:EmitSound("weapons/smg1/switch_single.wav")
		self.ViewModelFOV	= 70
		self:SetMode(RIFLE_MODE)
		self.Primary.Automatic = false
		self:SetHoldType("ar2")
		//self:ResetSequenceInfo()
		if CLIENT then
			chat.AddText("Rifle")
			self:AnimGun("weapon_rifle")
		end
	elseif self:GetMode() == PISTOL_MODE then
		//switch to smg mode
		self.Owner:EmitSound("weapons/smg1/switch_burst.wav")
		self.ViewModelFOV	= 60
		self:SetMode(SMG_MODE)
		self.Primary.Automatic = true
		self:SetHoldType("smg")
		//self:ResetSequenceInfo()
		if CLIENT then
			chat.AddText("SMG")
			self:AnimGun("weapon_smg")
		end
	elseif self:GetMode() == RIFLE_MODE then
		self.Owner:EmitSound("weapons/smg1/switch_single.wav")
		self.ViewModelFOV	= 50
		self:SetMode(PISTOL_MODE)
		self.Primary.Automatic = false
		self:SetHoldType("pistol")
		//self:ResetSequenceInfo()
		if CLIENT then
			chat.AddText("Pistol")
			self:AnimGun("weapon_pistol")
		end
	end
	self:SetNextSecondaryFire(CurTime() + 1.5)
end

function SWEP:Reload()
	if self.ReloadingTime and CurTime() <= self.ReloadingTime then return end

    if (self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
        self:EmitSound("weapons/pistol/pistol_reload1.wav")
        self:DefaultReload(ACT_VM_RELOAD)
        self.ReloadingTime = CurTime() + 1
        self:SetNextPrimaryFire(CurTime() + 1)
    end
end

function SWEP:AnimGun(anim)
	print(self:LookupSequence(anim))
	self:ResetSequence(self:LookupSequence(anim))
end