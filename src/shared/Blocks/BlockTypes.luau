export type Block = {
	Position: Vector3,
	Id: string,
	Color: Color3?,

	OnPlace: () -> ()?,
	OnDeletion: () -> ()?,
}

return {}
