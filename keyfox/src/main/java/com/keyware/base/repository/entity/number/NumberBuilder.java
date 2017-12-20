package com.keyware.base.repository.entity.number;


public class NumberBuilder {
    private String numberId;

    private Integer number;

    public String getNumberId() {
        return numberId;
    }

    public void setNumberId(String numberId) {
        this.numberId = numberId == null ? null : numberId.trim();
    }

	public Integer getNumber() {
		return number;
	}

	public void setNumber(Integer number) {
		this.number = number;
	}
}